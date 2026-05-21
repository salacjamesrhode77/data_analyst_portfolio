from airflow.models import Variable
import pendulum

from custom_functions.utils.dataframe_to_gcs import upload_df_to_gcs
from custom_functions.utils.idempotency_store import read_state, write_state
from .fetch_database import fetch_database_orders


def process_database_orders(bucket_name: str):

    instance_connection_name = "de-project-ecomm:asia-southeast1:ecomm-db"
    db_user = "airflow"
    db_pass = Variable.get("DB_PASSWORD")
    db_name = "ecomm_db"

    state_file = "idempotency_keys/db_orders_state.json"

    state = read_state(bucket_name, state_file, {"last_row_id": 0})
    last_row_id = int(state["last_row_id"])

    df = fetch_database_orders(instance_connection_name, db_user, db_pass, db_name, last_row_id)

    if df.empty:
        print("No new transactions to process.")
        return None

    now = pendulum.now()
    file_name = f"from_database/orders_{now.to_datetime_string().replace(':','').replace(' ','_')}.csv"
    upload_df_to_gcs(df, bucket_name, file_name)

    new_last_row_id = int(df["row_id"].max())
    write_state(bucket_name, state_file, {"last_row_id": new_last_row_id})

    print(f"Processed {len(df)} rows and uploaded to {file_name}")
    return file_name