import pandas as pd
from bs4 import BeautifulSoup

def parse_emails_to_df(emails: list[dict]) -> pd.DataFrame:

    all_rows = []

    for e in emails:
        body = e["body"]
        email_timestamp = e["email_timestamp"]

        soup = BeautifulSoup(body, 'html.parser')

        customer = soup.find(text="Customer:").parent.next_sibling.strip()
        order_date = soup.find(text="Order Date:").parent.next_sibling.strip()
        total_amount = soup.find_all('tr')[-1].find_all('td')[-1].text.strip()

        payment_method = soup.find(text="Payment Method:").parent.next_sibling.strip()
        payment_reference = soup.find(text="Payment Reference:").parent.next_sibling.strip()
        payment_date = soup.find(text="Payment Date:").parent.next_sibling.strip()

        for tr in soup.find_all('tr')[1:-1]:
            tds = [td.text.strip() for td in tr.find_all('td')]

            all_rows.append({
                'customer': customer,
                'product': tds[0],
                'sku': tds[1],
                'qty': tds[2],
                'price': tds[3],
                'line_total': tds[4],
                'total_amount': total_amount,
                'payment_method': payment_method,
                'payment_reference': payment_reference,
                'order_date': order_date,
                'payment_date': payment_date,
                'email_timestamp': email_timestamp
            })

    return pd.DataFrame(all_rows)
