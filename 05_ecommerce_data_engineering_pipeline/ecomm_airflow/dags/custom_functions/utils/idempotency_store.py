from google.cloud import storage
import json

def read_state(bucket_name: str, state_file: str, default: dict) -> dict:
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(state_file)

    if not blob.exists():
        return default

    content = blob.download_as_text()
    return json.loads(content)


def write_state(bucket_name: str, state_file: str, state_dict: dict):
    client = storage.Client()
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(state_file)
    blob.upload_from_string(json.dumps(state_dict),content_type="application/json")