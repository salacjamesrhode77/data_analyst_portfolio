import pandas as pd

from google.cloud.sql.connector import Connector
from sqlalchemy import create_engine

connector = Connector()

def get_postgres_engine(instance_connection_name: str, db_user: str, db_pass: str, db_name: str):

    def getconn():
        return connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_pass,
            db=db_name
        )

    engine = create_engine("postgresql+pg8000://", creator=getconn)
    return engine

def fetch_database_orders(
    instance_connection_name: str,
    db_user: str,
    db_pass: str,
    db_name: str,
    last_row_id: int
) -> pd.DataFrame:
    engine = get_postgres_engine(instance_connection_name, db_user, db_pass, db_name)

    query = f"""
        SELECT *
        FROM orders
        WHERE row_id > {last_row_id}
        ORDER BY row_id ASC;
    """

    df = pd.read_sql(query, engine)
    return df