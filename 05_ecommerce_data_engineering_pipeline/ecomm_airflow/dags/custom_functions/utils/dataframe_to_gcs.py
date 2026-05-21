import csv
import pandas as pd
from io import StringIO
from google.cloud import storage

def upload_df_to_gcs(df: pd.DataFrame, bucket_name: str, file_name: str) -> None:

    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False, quoting=csv.QUOTE_ALL, encoding="utf-8-sig")
    csv_data = csv_buffer.getvalue()

    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    blob.upload_from_string(csv_data, content_type="text/csv")

    print(f"Uploaded CSV to: gs://{bucket_name}/{file_name}")