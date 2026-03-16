from __future__ import annotations

from datetime import datetime, timedelta


DEFAULT_ARGS = {
    "owner": "data-platform",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=10),
}


def dataset_freshness_sla(hours: int) -> dict[str, str]:
    return {
        "checked_at": datetime.utcnow().isoformat(),
        "sla_hours": str(hours),
    }
