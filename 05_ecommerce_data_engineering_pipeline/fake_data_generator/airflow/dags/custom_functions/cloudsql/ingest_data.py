import random
from datetime import datetime, timedelta
from typing import List

import pandas as pd
from faker import Faker
from sqlalchemy import create_engine
from google.cloud.sql.connector import Connector
from airflow.models import Variable

from custom_functions.utils.generate_orders import generate_orders
from custom_functions.cloudsql.create_db_connection import ingest_dataframe_to_cloudsql


def run_cloudsql_orders_pipeline():

    products_df = pd.read_csv("/opt/airflow/data/fake_products.csv")
    customers_df = pd.read_csv("/opt/airflow/data/fake_dbcustomers.csv")
    customers_df = customers_df.drop(columns=["First Name", "Last Name"])

    orders_df = generate_orders(
        customers_df=customers_df,
        products_df=products_df,
        num_orders=800,
        reference_date=datetime.now() - timedelta(days=1),
    )

    ingest_dataframe_to_cloudsql(
        df=orders_df,
        table_name="orders",
        instance_connection_name="de-project-ecomm:asia-southeast1:ecomm-db",
        db_user="airflow",
        db_password=Variable.get("db_password"),
        db_name="ecomm_db",
        if_exists="append",
        chunksize=1000,
    )
