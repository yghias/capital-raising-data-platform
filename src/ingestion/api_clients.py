from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from src.common.config import get_settings
from src.common.logging import configure_logging
from src.common.models import SourceEnvelope
from src.ingestion.contracts import assert_required_keys


def _checksum(payload: dict) -> str:
    serialized = json.dumps(payload, sort_keys=True).encode("utf-8")
    return hashlib.sha256(serialized).hexdigest()[:16]


def load_mock_market_intel() -> list[SourceEnvelope]:
    payloads = [
        {
            "company_name": "AtlasPay",
            "investor_name": "North Harbor Growth Partners",
            "round_type": "Series B",
            "amount_usd": 45000000,
            "sector": "Fintech",
            "announcement_date": "2026-02-10",
        },
        {
            "company_name": "GridForge",
            "investor_name": "Summit Ridge Ventures",
            "round_type": "Series A",
            "amount_usd": 18000000,
            "sector": "Industrial AI",
            "announcement_date": "2026-02-23",
        },
    ]
    timestamp = datetime.now(timezone.utc)
    required_keys = {"company_name", "investor_name", "round_type", "announcement_date", "amount_usd"}
    return [
        SourceEnvelope(
            source_system="market_intel_api",
            entity_type="fundraising_signal",
            source_record_id=f"market-{index + 1}",
            extracted_at=timestamp,
            checksum=_checksum(payload),
            payload=payload,
        )
        for index, payload in enumerate(_validated_payloads(payloads, required_keys))
    ]


def _validated_payloads(payloads: list[dict], required_keys: set[str]) -> list[dict]:
    for payload in payloads:
        assert_required_keys(payload, required_keys)
    return payloads


def write_raw_extract(envelopes: list[SourceEnvelope]) -> Path:
    settings = get_settings()
    output_dir = settings.raw_data_dir / "raw_extracts"
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / "market_intel_latest.json"
    output_path.write_text(
        json.dumps([envelope.model_dump(mode="json") for envelope in envelopes], indent=2),
        encoding="utf-8",
    )
    return output_path


def main() -> None:
    settings = get_settings()
    configure_logging(settings.log_level)
    extract = load_mock_market_intel()
    path = write_raw_extract(extract)
    print(f"Wrote {len(extract)} source envelopes to {path}")


if __name__ == "__main__":
    main()
