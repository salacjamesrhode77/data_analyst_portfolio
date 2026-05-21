from airflow.hooks.base import BaseHook
import snowflake.connector

def load_csv_to_snowflake(
    table_name: str,
    stage_name: str,
    file_name: str
) -> None:

    conn = BaseHook.get_connection("snowflake_conn")

    ctx = snowflake.connector.connect(
        user=conn.login,
        password=conn.password,
        schema=conn.schema,
        account=conn.extra_dejson.get("account"),
        warehouse=conn.extra_dejson.get("warehouse"),
        database=conn.extra_dejson.get("database"),
        role=conn.extra_dejson.get("role", "PUBLIC")
    )
    cs = ctx.cursor()

    try:
        copy_sql = f"""
        COPY INTO {table_name}
        FROM @{stage_name}/{file_name}
        ON_ERROR = 'ABORT_STATEMENT';
        """
        cs.execute(copy_sql)
        print(f"Data copied from stage {stage_name} to table {table_name}.")
    finally:
        cs.close()
        ctx.close()
