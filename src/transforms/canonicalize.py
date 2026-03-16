from __future__ import annotations

import re


LEGAL_SUFFIXES = {
    "partners",
    "capital",
    "ventures",
    "management",
    "holdings",
    "llc",
    "lp",
    "l.p.",
    "inc",
}


def normalize_name(name: str) -> str:
    """Build a warehouse-compatible normalization key for source-side validation.

    Canonical entity assembly remains SQL-first in the warehouse models. This helper
    exists only to keep ingestion-time checks and test fixtures aligned with the
    normalized naming rules used in the dbt-style intermediate layer.
    """

    cleaned = re.sub(r"[^a-z0-9 ]", " ", name.lower())
    tokens = [token for token in cleaned.split() if token not in LEGAL_SUFFIXES]
    return " ".join(tokens)
