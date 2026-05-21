import pandas as pd
import sqlalchemy
from google.cloud.sql.connector import Connector

def ingest_dataframe_to_cloudsql(
    df: pd.DataFrame,
    table_name: str,
    instance_connection_name: str,
    db_user: str,
    db_password: str,
    db_name: str,
    if_exists: str = "append",
    chunksize: int = 1_000,
):

    connector = Connector()

    def getconn():
        return connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_password,
            db=db_name,
        )

    engine = sqlalchemy.create_engine(
        "postgresql+pg8000://",
        creator=getconn,
    )

    try:
        df.to_sql(
            name=table_name,
            con=engine,
            if_exists=if_exists,
            index=False,
            chunksize=chunksize,
            method="multi",
        )
    finally:
        engine.dispose()
        connector.close()
