from __future__ import annotations

from collections.abc import Iterable


def assert_required_keys(payload: dict, required_keys: Iterable[str]) -> None:
    missing = sorted(key for key in required_keys if key not in payload or payload[key] in (None, ""))
    if missing:
        raise ValueError(f"Payload missing required keys: {missing}")
