from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class Settings:
    app_env: str = os.getenv("APP_ENV", "local")
    log_level: str = os.getenv("LOG_LEVEL", "INFO")
    raw_data_dir: Path = Path(os.getenv("RAW_DATA_DIR", "sample_data"))
    match_threshold: float = float(os.getenv("CANONICAL_MATCH_THRESHOLD", "0.85"))
    top_target_count: int = int(os.getenv("TOP_TARGET_COUNT", "25"))


def get_settings() -> Settings:
    return Settings()
