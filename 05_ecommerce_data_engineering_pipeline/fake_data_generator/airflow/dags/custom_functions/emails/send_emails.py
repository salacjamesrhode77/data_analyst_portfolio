import pandas as pd
from datetime import datetime, timedelta
from airflow.models import Variable

from custom_functions.utils.generate_orders import generate_orders
from custom_functions.emails.create_emails import create_email_bodies

def run_email_orders_pipeline():

    customers_df = pd.read_csv("/opt/airflow/data/fake_customers.csv")
    products_df = pd.read_csv("/opt/airflow/data/fake_products.csv")

    orders_df = generate_orders(
        customers_df=customers_df,
        products_df=products_df,
        num_orders=100,
        reference_date=datetime.now() - timedelta(days=1),
    )

    create_email_bodies(
        orders_df=orders_df,
        email_sender=Variable.get("email_sender"),
        email_password=Variable.get("email_password"),
        email_recipient=Variable.get("email_recipient"),
        smtp_server="smtp.gmail.com",
        smtp_port=465,
        delay=1.0
    )
