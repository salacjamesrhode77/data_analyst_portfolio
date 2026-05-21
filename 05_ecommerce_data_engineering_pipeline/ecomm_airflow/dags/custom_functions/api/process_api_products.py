import requests
import pandas as pd

from custom_functions.utils.dataframe_to_gcs import upload_df_to_gcs

def fetch_products_from_api(base_url: str, page_limit: int) -> pd.DataFrame:

    products_data = []
    page = 1

    while True:
        try:
            response = requests.get(f"{base_url}/products?page={page}&limit={page_limit}", timeout=10)
            response.raise_for_status()
        except requests.RequestException as e:
            raise ConnectionError(f"Failed to fetch products: {e}")
        
        data = response.json()
        if not data:
            break

        products_data.extend(data)
        page += 1

    if not products_data:
        raise ValueError("No products returned from API.")

    df = pd.DataFrame(products_data)
    return df


def process_api_products(base_url: str, page_limit: int, bucket_name: str) -> str:

    df = fetch_products_from_api(base_url, page_limit)

    file_name = "from_api/products_latest.csv"
    upload_df_to_gcs(df, bucket_name, file_name)

    return file_name