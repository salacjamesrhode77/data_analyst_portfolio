from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
import pendulum

with DAG(
    dag_id="fake_data_orchestrator",
    start_date=pendulum.datetime(2025, 12, 1, tz=pendulum.timezone("Asia/Manila")),
    schedule="30 10 * * *",
    catchup=False
) as dag:
    
    trigger_email_orders_generator = TriggerDagRunOperator(
        task_id="trigger_email_orders_generator",
        trigger_dag_id="email_orders_generator",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "fake_data_orchestrator"},
    )

    trigger_database_orders_generator = TriggerDagRunOperator(
        task_id="trigger_database_orders_generator",
        trigger_dag_id="database_orders_generator",
        wait_for_completion=True,
        poke_interval=30,
        conf={"triggered_by": "fake_data_orchestrator"},
    )

    trigger_email_orders_generator >> trigger_database_orders_generator