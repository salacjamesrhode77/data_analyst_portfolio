# dags/ingest_multi_datasets_taskflow.py
from datetime import datetime
from docker.types import Mount
import tempfile
import os
import requests
import pendulum

from airflow import DAG
from airflow.decorators import task
from airflow.models import Variable
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook

from custom_dags.config.datasets import DATASETS

# -----------------------------
# DAG default arguments
# -----------------------------
DEFAULT_ARGS = {"retries": 1}

# -----------------------------
# Airflow Variables
# -----------------------------
DBT_PROJECT_PATH = Variable.get("dbt_project_path")  # path to local dbt project
DOCKER_NETWORK = Variable.get("docker_network")  # e.g., "maven-network"

# -----------------------------
# DAG definition
# -----------------------------
local_tz = pendulum.timezone("Asia/Manila")

with DAG(
    dag_id="ingest_multiple_csvs",
    start_date=pendulum.datetime(2025, 11, 22, tz=local_tz),
    schedule="0 0 * * 1",
    catchup=False,
    default_args=DEFAULT_ARGS,
    max_active_runs=1,
    tags=["ingest"]
) as dag:

    # -----------------------------
    # Step 1: Create tables
    # -----------------------------
    create_table_ops = {}
    for ds in DATASETS:
        create_table_ops[ds["name"]] = SQLExecuteQueryOperator(
            task_id=f"create_table__{ds['name']}",
            sql=ds["create_sql"],
            conn_id="postgres_conn",
        )

    # -----------------------------
    # Step 2: Ingest datasets
    # -----------------------------
    @task
    def ingest_all_datasets(dataset_configs):
        """Download CSVs and load them into Postgres."""
        hook = PostgresHook(postgres_conn_id="postgres_conn")

        for cfg in dataset_configs:
            # Get CSV URL from Airflow Variable
            url = Variable.get(cfg["url_variable"])
            
            # Download CSV to temp file
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            tmp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".csv")
            tmp_file.write(response.content)
            tmp_file.flush()
            tmp_file.close()
            
            # Copy into Postgres
            sql = f"COPY {cfg['table']} FROM STDIN WITH CSV HEADER DELIMITER ','"
            hook.copy_expert(sql=sql, filename=tmp_file.name)
            
            # Cleanup temp file
            try:
                os.remove(tmp_file.name)
            except Exception:
                pass

    ingest_task = ingest_all_datasets(DATASETS)

    # Set table creation dependencies
    for ds in DATASETS:
        create_table_ops[ds["name"]] >> ingest_task

    # -----------------------------
    # Step 3: DBT tasks in DockerOperator
    # -----------------------------
    def create_dbt_task(task_id: str, command: str):
        return DockerOperator(
            task_id=task_id,
            image="maven_dbt:latest",
            api_version="auto",
            auto_remove="force",
            command=f"{command} --profiles-dir /usr/app/dbt",
            network_mode=DOCKER_NETWORK,
            mounts=[Mount(source=DBT_PROJECT_PATH, target="/usr/app/dbt", type="bind")],
        )

    dbt_debug = create_dbt_task("dbt_debug", "debug")
    dbt_deps = create_dbt_task("dbt_deps", "deps")
    dbt_run = create_dbt_task("dbt_run", "run")

    # -----------------------------
    # Step 4: Set task dependencies
    # -----------------------------
    ingest_task >> dbt_debug >> dbt_deps >> dbt_run
