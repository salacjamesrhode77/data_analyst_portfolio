from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
import pendulum

from custom_functions import process_database_orders, load_csv_to_snowflake

with DAG(
    dag_id="ingest_database_orders",
    start_date=pendulum.datetime(2025, 11, 22, tz=pendulum.timezone("Asia/Manila")),
    schedule=None,
    catchup=False,
) as dag:

    process_orders = PythonOperator(
        task_id="process_database_orders_to_gcs",
        python_callable=process_database_orders,
        op_kwargs={
            "bucket_name": Variable.get("GCS_BUCKET")
        },
    )

    load_database_orders = PythonOperator(
        task_id="load_database_orders_to_snowflake",
        python_callable=load_csv_to_snowflake,
        op_kwargs={
            "table_name": "ECOMM.DATABASE_ORDERS",
            "stage_name": "MY_GCS_STAGE",
            "file_name": "{{ ti.xcom_pull(task_ids='process_database_orders_to_gcs') }}"
        }
    )

    process_orders >> load_database_orders
