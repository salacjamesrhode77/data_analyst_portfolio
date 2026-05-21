import random
import time
import smtplib
import ssl
from datetime import datetime, timedelta
from typing import List

import pandas as pd
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def create_email_bodies(
    orders_df: pd.DataFrame,
    email_sender: str,
    email_password: str,
    email_recipient: str,
    smtp_server: str = "smtp.gmail.com",
    smtp_port: int = 465,
    delay: float = 2.0,
):

    orders_df["payment_date"] = pd.to_datetime(
        orders_df["payment_date"], errors="coerce"
    )

    context = ssl.create_default_context()
    grouped = orders_df.groupby("billing_name")

    with smtplib.SMTP_SSL(smtp_server, smtp_port, context=context) as smtp:
        smtp.login(email_sender, email_password)

        for customer_name, orders in grouped:
            msg = MIMEMultipart("alternative")
            msg["Subject"] = f"[demo-store] Order Confirmation for {customer_name}"
            msg["From"] = email_sender
            msg["To"] = email_recipient

            first_order = orders.iloc[0]

            rows_html = ""
            total_amount = 0

            for _, row in orders.iterrows():
                line_total = row["lineitem_qty"] * row["unit_price"]
                total_amount += line_total

                rows_html += f"""
                <tr>
                    <td>{row['lineitem_name']}</td>
                    <td>{row['product_sku']}</td>
                    <td>{row['lineitem_qty']}</td>
                    <td>₱{row['unit_price']}</td>
                    <td>₱{line_total:.2f}</td>
                </tr>
                """

            rows_html += f"""
            <tr style="font-weight:bold;background-color:#f2f2f2;">
                <td colspan="4" style="text-align:right;">Total Amount</td>
                <td>₱{total_amount:.2f}</td>
            </tr>
            """

            html_content = f"""
            <html>
            <body>
                <h2>Order Confirmation</h2>
                <p><b>Customer:</b> {customer_name}</p>
                <p><b>Order Date:</b> {first_order['order_date']}</p>

                <h3>Order Summary</h3>
                <table border="1" cellpadding="5" cellspacing="0">
                    <tr>
                        <th>Product</th>
                        <th>SKU</th>
                        <th>Qty</th>
                        <th>Price</th>
                        <th>Line Total</th>
                    </tr>
                    {rows_html}
                </table>

                <h3>Payment Details</h3>
                <p><b>Payment Method:</b> {first_order['payment_method']}</p>
                <p><b>Payment Reference:</b> {first_order['payment_reference']}</p>
                <p><b>Payment Date:</b> {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}</p>

                <hr>
                <p>This is a demo confirmation email for testing purposes only.</p>
            </body>
            </html>
            """

            msg.attach(MIMEText(html_content, "html"))
            smtp.sendmail(email_sender, email_recipient, msg.as_string())
            print(f"Sent email for {customer_name}")

            time.sleep(delay)