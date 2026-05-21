import email
from email import policy
from email.utils import parsedate_to_datetime
import imaplib
import pendulum

def get_email_body(message):
    if message.is_multipart():
        for part in message.iter_parts():
            content_type = part.get_content_type()
            if content_type in ("text/plain", "text/html"):
                return part.get_content()
    return message.get_content()


def fetch_email_bodies(
    user: str,
    password: str,
    last_timestamp: pendulum.DateTime,
    subject_filter='[demo-store] Order Confirmation for',
    imap_url='imap.gmail.com'
) -> list:
    """
    Fetch only new emails (using email header Date field)
    """
    mail = imaplib.IMAP4_SSL(imap_url)
    mail.login(user, password)
    mail.select('Inbox')

    status, data = mail.search(
        None,
        'SUBJECT', f'"{subject_filter}"'
    )
    email_ids = data[0].split()
    results = []

    for email_id in email_ids:
        status, data = mail.fetch(email_id, '(RFC822)')
        for _, raw_msg in (part for part in data if isinstance(part, tuple)):

            msg = email.message_from_bytes(raw_msg, policy=policy.default)

            email_ts = pendulum.instance(
                parsedate_to_datetime(msg.get("Date"))
            )

            if email_ts <= last_timestamp:
                continue

            results.append({
                "body": get_email_body(msg),
                "email_timestamp": email_ts.to_iso8601_string()
            })

    mail.logout()
    return results
