from __future__ import annotations

from pathlib import Path

import pandas as pd


def load_crm_relationships(csv_path: str | Path) -> pd.DataFrame:
    frame = pd.read_csv(csv_path)
    expected = {
        "investor_name",
        "relationship_owner",
        "last_meeting_date",
        "warm_intro_path",
        "relationship_strength",
    }
    missing = expected.difference(frame.columns)
    if missing:
        raise ValueError(f"Missing required CRM columns: {sorted(missing)}")
    return frame


if __name__ == "__main__":
    df = load_crm_relationships("sample_data/crm_relationships.csv")
    print(df.head().to_string(index=False))
