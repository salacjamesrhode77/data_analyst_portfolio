import pendulum

from custom_functions.utils.dataframe_to_gcs import upload_df_to_gcs
from custom_functions.utils.idempotency_store import read_state, write_state
from .fetch_email import fetch_email_bodies
from .parse_email import parse_emails_to_df

def process_email_orders(
    user: str,
    password: str,
    bucket_name: str,
    subject_filter='[demo-store] Order Confirmation for',
    imap_url='imap.gmail.com'
) -> str:

    state_file = "idempotency_keys/email_orders_state.json"
    default_state = {"last_email_timestamp": "1970-01-01T00:00:00Z"}

    state = read_state(bucket_name, state_file, default_state)
    last_ts = pendulum.parse(state["last_email_timestamp"])

    emails = fetch_email_bodies(
        user, password, last_ts, subject_filter, imap_url
    )

    if not emails:
        print("No new emails to process.")
        return None

    df = parse_emails_to_df(emails)

    now = pendulum.now()
    file_name = f"from_emails/orders_{now.to_datetime_string().replace(':','').replace(' ','_')}.csv"
    upload_df_to_gcs(df, bucket_name, file_name)

    new_last_ts = max(pendulum.parse(e["email_timestamp"]) for e in emails)
    write_state(bucket_name, state_file, {"last_email_timestamp": new_last_ts.to_iso8601_string()})

    print(f"Processed {len(df)} rows. Latest timestamp: {new_last_ts}")

    return file_name