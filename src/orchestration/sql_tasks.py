from __future__ import annotations

from pathlib import Path


SQL_DEPLOYMENT_ASSETS = [
    Path("sql/schema.sql"),
    Path("sql/canonicalization.sql"),
    Path("sql/marts.sql"),
    Path("sql/semantic_metrics.sql"),
    Path("sql/monitoring.sql"),
    Path("sql/tests.sql"),
    Path("sql/reconciliation.sql"),
]


def validate_sql_assets() -> None:
    missing = [str(path) for path in SQL_DEPLOYMENT_ASSETS if not path.exists()]
    if missing:
        raise FileNotFoundError(f"Missing SQL deployment assets: {missing}")


def print_deployment_order() -> None:
    for index, asset in enumerate(SQL_DEPLOYMENT_ASSETS, start=1):
        print(f"{index}. {asset}")
