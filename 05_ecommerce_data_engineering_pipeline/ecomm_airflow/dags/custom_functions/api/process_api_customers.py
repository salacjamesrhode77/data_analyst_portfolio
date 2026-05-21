import requests
import pandas as pd

from custom_functions.utils.dataframe_to_gcs import upload_df_to_gcs


def fetch_customers_from_api(base_url):
    response = requests.get(f"{base_url}/customers")
    if response.status_code == 200:
        data = response.json()
        df = pd.DataFrame(data)
        return df
    else:
        print(f"Error fetching customers: {response.status_code}")
        return None

    
def process_api_customers(
    base_url: str,
    bucket_name: str
) -> str:

    df = fetch_customers_from_api(base_url)

    file_name = "from_api/customers_latest.csv"
    upload_df_to_gcs(df, bucket_name, file_name)

    return file_name