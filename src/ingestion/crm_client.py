from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path

from src.common.config import get_settings
from src.common.models import SourceEnvelope
from src.ingestion.contracts import assert_required_keys


def _checksum(payload: dict) -> str:
    return hashlib.sha256(json.dumps(payload, sort_keys=True).encode("utf-8")).hexdigest()[:16]


def load_mock_crm_activity() -> list[SourceEnvelope]:
    payloads = [
        {
            "crm_account_id": "SF-ACCT-2942",
            "investor_name": "North Harbor Growth Partners",
            "relationship_owner": "Alyssa Cole",
            "activity_type": "meeting",
            "activity_date": "2026-02-24",
            "outcome": "meeting_booked",
            "warm_intro_path": "Advisor -> Existing LP -> Partner",
            "relationship_strength": 0.91,
        },
        {
            "crm_account_id": "SF-ACCT-3114",
            "investor_name": "Catalyst Peak Capital",
            "relationship_owner": "Nina Patel",
            "activity_type": "intro",
            "activity_date": "2026-03-02",
            "outcome": "diligence",
            "warm_intro_path": "Board member intro",
            "relationship_strength": 0.86,
        },
    ]
    required_keys = {
        "crm_account_id",
        "investor_name",
        "relationship_owner",
        "activity_type",
        "activity_date",
        "outcome",
    }
    timestamp = datetime.now(timezone.utc)
    envelopes: list[SourceEnvelope] = []
    for index, payload in enumerate(payloads, start=1):
        assert_required_keys(payload, required_keys)
        envelopes.append(
            SourceEnvelope(
                source_system="crm_salesforce",
                entity_type="crm_activity",
                source_record_id=f"crm-{index}",
                extracted_at=timestamp,
                checksum=_checksum(payload),
                payload=payload,
            )
        )
    return envelopes


def write_raw_extract(envelopes: list[SourceEnvelope]) -> Path:
    settings = get_settings()
    output_dir = settings.raw_data_dir / "raw_extracts"
    output_dir.mkdir(parents=True, exist_ok=True)
    output_path = output_dir / "crm_activity_latest.json"
    output_path.write_text(
        json.dumps([envelope.model_dump(mode="json") for envelope in envelopes], indent=2),
        encoding="utf-8",
    )
    return output_path


def main() -> None:
    extract = load_mock_crm_activity()
    path = write_raw_extract(extract)
    print(f"Wrote {len(extract)} CRM envelopes to {path}")


if __name__ == "__main__":
    main()
