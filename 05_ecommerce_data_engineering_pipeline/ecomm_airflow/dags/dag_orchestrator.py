from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import pendulum

with DAG(
    dag_id="orchestrator_elt_pipeline",
    start_date=pendulum.datetime(2025, 12, 1, tz=pendulum.timezone("Asia/Manila")),
    schedule="45 10 * * 1",
    catchup=False
) as dag:
    
    trigger_ingest_api_dimension = TriggerDagRunOperator(
        task_id="trigger_api_ingestion",
        trigger_dag_id="ingest_api_dimension",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "orchestrator_elt_pipeline"},
    )

    trigger_ingest_database_orders = TriggerDagRunOperator(
        task_id="trigger_database_ingestion",
        trigger_dag_id="ingest_database_orders",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "orchestrator_elt_pipeline"},
    )

    trigger_ingest_email_orders = TriggerDagRunOperator(
        task_id="trigger_email_ingestion",
        trigger_dag_id="ingest_email_orders",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "orchestrator_elt_pipeline"},
    )

    trigger_execute_dbt = TriggerDagRunOperator(
        task_id="trigger_dbt_operations",
        trigger_dag_id="execute_dbt_operations",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "orchestrator_elt_pipeline"},
    )

    trigger_ingest_api_dimension >> [trigger_ingest_email_orders, trigger_ingest_database_orders] >> trigger_execute_dbt