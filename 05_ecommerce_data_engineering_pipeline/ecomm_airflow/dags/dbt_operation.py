from airflow import DAG
from cosmos import DbtTaskGroup, DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig, ExecutionMode
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
from pendulum import datetime
import os


profile_config = ProfileConfig(
    profile_name="cosmos",
    target_name="dev",
    profile_mapping = SnowflakeUserPasswordProfileMapping(
        conn_id = 'snowflake_conn',
    ),
)

project_config = ProjectConfig(
    dbt_project_path=f"{os.environ['AIRFLOW_HOME']}/dags/dbt/ecomm_dbt",
)

execution_config = ExecutionConfig(
    dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",
    execution_mode=ExecutionMode.LOCAL,
)

render_config = RenderConfig()

with DAG(
    dag_id="execute_dbt_operations",
    start_date=datetime(2025, 12, 7),
    schedule=None,
):

    execute_dbt = DbtTaskGroup(
        group_id="dbt_task",
        project_config=project_config,
        profile_config=profile_config,
        execution_config=execution_config,
        render_config=render_config,
    )

    execute_dbt