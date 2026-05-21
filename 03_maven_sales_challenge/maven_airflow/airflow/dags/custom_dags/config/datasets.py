# dags/config/datasets_config.py

DATASETS = [
    {
        "name": "accounts",
        "url_variable": "accounts_csv_url",
        "table": "accounts",
        "create_sql": "sql/create_table_accounts.sql"
    },
    {
        "name": "products",
        "url_variable": "products_csv_url",
        "table": "products",
        "create_sql": "sql/create_table_products.sql"
    },
    {
        "name": "sales_teams",
        "url_variable": "sales_teams_csv_url",
        "table": "sales_teams",
        "create_sql": "sql/create_table_sales_pipeline.sql"
    },
    {
        "name": "sales_pipeline",
        "url_variable": "sales_pipeline_csv_url",
        "table": "sales_pipeline",
        "create_sql": "sql/create_table_sales_teams.sql"
    },
]
