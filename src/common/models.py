from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, Field


class SourceEnvelope(BaseModel):
    source_system: str
    entity_type: str
    source_record_id: str
    extracted_at: datetime
    checksum: str
    payload: dict[str, Any]


class CanonicalInvestor(BaseModel):
    canonical_investor_id: str
    display_name: str
    investor_type: str
    focus_sectors: list[str] = Field(default_factory=list)
    preferred_stages: list[str] = Field(default_factory=list)
    headquarters_country: str | None = None
    aum_usd: float | None = None
    relationship_strength: float = 0.0
    signal_score: float = 0.0
    fit_score: float = 0.0
    priority_score: float = 0.0
    source_attribution: list[dict[str, Any]] = Field(default_factory=list)
