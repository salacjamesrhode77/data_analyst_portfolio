import pandas as pd
import re

def dataframe_to_lookup(
    df: pd.DataFrame,
    key_col: str,
    exclude: list[str] | None = None,
):
    exclude = set(exclude or []) | {key_col}

    return {
        row[key_col]: {k: v for k, v in row.items() if k not in exclude}
        for _, row in df.iterrows()
    }


def snake_case_formatting(s: str) -> str:
    s = re.sub(r"[^\w\s]", "", s)
    s = re.sub(r"\s+", "_", s)
    return s.lower()
