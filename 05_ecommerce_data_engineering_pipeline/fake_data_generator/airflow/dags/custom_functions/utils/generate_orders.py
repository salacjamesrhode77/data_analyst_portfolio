import random
from datetime import datetime, timedelta
from typing import List
import pandas as pd

from .lineitem_orders import generate_line_items_for_order
from .helper_functions import dataframe_to_lookup, snake_case_formatting

def generate_orders(
    customers_df: pd.DataFrame,
    products_df: pd.DataFrame,
    num_orders: int,
    payment_methods: list[str] | None = None,
    reference_date: datetime | None = None,
) -> pd.DataFrame:

    if payment_methods is None:
        payment_methods = [
            "PayPal",
            "Digital Wallet",
            "Cash on Delivery",
            "Bank Transfer",
        ]

    if reference_date is None:
        reference_date = datetime.now() - timedelta(days=1)

    customers = customers_df["Full Name"].tolist()
    products = products_df["Title"].tolist()

    random_number = lambda: f"#{random.randint(100_000_000_000, 999_999_999_999)}"

    customer_lookup = dataframe_to_lookup(customers_df, "Full Name")
    product_lookup = dataframe_to_lookup(products_df, "Title")

    data = []

    for _ in range(num_orders):
        order_number = random_number()
        order_date = reference_date + timedelta(
            seconds=random.randint(0, 86399)
        )

        billing_name = random.choice(customers)
        payment_method = random.choice(payment_methods)
        payment_reference = random_number()

        data.extend(
            generate_line_items_for_order(
                order_number,
                order_date,
                billing_name,
                payment_method,
                payment_reference,
                products,
                customer_lookup,
                product_lookup,
            )
        )

    df = pd.DataFrame(data)
    df.columns = [snake_case_formatting(col) for col in df.columns]

    return df
