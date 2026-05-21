from airflow import DAG
from airflow.operators.python import PythonOperator
import pendulum

from custom_functions import run_email_orders_pipeline

with DAG(
    dag_id="email_orders_generator",
    start_date=pendulum.datetime(2025, 12, 2, tz=pendulum.timezone("Asia/Manila")),
    schedule=None,
    catchup=False
) as dag:

    run_email_orders_pipeline_task = PythonOperator(
        task_id="run_email_orders_pipeline",
        python_callable=run_email_orders_pipeline
    )
