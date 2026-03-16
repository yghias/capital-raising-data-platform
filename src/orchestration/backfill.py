from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class BackfillRequest:
    dataset: str
    start_date: str
    end_date: str
    reason: str


def plan_backfill(request: BackfillRequest) -> str:
    return (
        f"Backfill planned for {request.dataset} from {request.start_date} to {request.end_date}. "
        f"Reason: {request.reason}. Run reconciliation after publish."
    )


if __name__ == "__main__":
    print(
        plan_backfill(
            BackfillRequest(
                dataset="capital_markets_std.stg_market_intel_rounds",
                start_date="2026-03-01",
                end_date="2026-03-15",
                reason="provider schema correction",
            )
        )
    )
