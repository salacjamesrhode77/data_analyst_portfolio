import random
from datetime import datetime, timedelta
from typing import List, Dict

def generate_line_items_for_order(
    order_number: str,
    order_date: datetime,
    billing_name: str,
    payment_method: str,
    payment_reference: str,
    products: List[str],
    customer_lookup: Dict[str, dict],
    product_lookup: Dict[str, dict],
) -> List[Dict]:

    records = []

    for _ in range(random.randint(1, 3)):
        product_name = random.choice(products)

        record = {
            "order_number": order_number,
            "order_date": order_date,
            "billing_name": billing_name,
            "lineitem_name": product_name,
            "lineitem_qty": random.randint(1, 3),
            "payment_method": payment_method,
            "payment_reference": payment_reference,
            "payment_date": order_date + timedelta(days=random.uniform(0, 1)),
            "fulfillment_date": order_date + timedelta(days=random.uniform(1, 2)),
        }

        record.update(customer_lookup.get(billing_name, {}))
        record.update(product_lookup.get(product_name, {}))

        records.append(record)

    return records
