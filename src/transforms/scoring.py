from __future__ import annotations

from pathlib import Path

import pandas as pd

from src.common.config import get_settings

WAREHOUSE_EXPORT = Path("sample_data") / "warehouse_exports" / "mart_investor_priority.csv"


def load_priority_mart_export(path: Path = WAREHOUSE_EXPORT) -> pd.DataFrame:
    """Load a local export of the SQL-built mart for operational review flows."""

    return pd.read_csv(path, parse_dates=["investor_priority_date", "latest_signal_date"])


def main() -> None:
    settings = get_settings()
    ranked = load_priority_mart_export().sort_values("priority_score", ascending=False)
    top_targets = ranked.head(settings.top_target_count)
    print(top_targets[["canonical_investor_id", "display_name", "priority_score"]].to_string(index=False))


if __name__ == "__main__":
    main()
