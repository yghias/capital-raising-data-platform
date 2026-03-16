# Runbook

## Purpose
This runbook provides operator guidance for common incidents affecting the capital-raising data platform.

## Critical services
- source ingestion jobs
- canonical publish workflow
- analytical marts build
- scoring and ranking batch
- executive reporting datasets

## Common incidents

### Source API failure
Symptoms:
- extraction task retries exhaust
- freshness breach for a source-aligned table

Operator actions:
1. confirm whether the failure is authentication, rate limit, or upstream outage
2. review last successful watermark and impacted downstream datasets
3. rerun the source task after remediation through Airflow or via the relevant local entry point:
   `python -m src.ingestion.api_clients` or `python -m src.ingestion.crm_client`
4. if source remains unavailable, publish a degraded-service notice and suppress dependent alerts

### Entity resolution confidence collapse
Symptoms:
- sudden increase in unmatched or low-confidence records
- duplicate surge in canonical investors or companies

Operator actions:
1. inspect recent source schema or taxonomy changes
2. compare confidence distributions against the prior successful run
3. pause canonical publish if confidence breaches threshold
4. route affected clusters to stewardship review

### Executive mart reconciliation failure
Symptoms:
- KPI variance exceeds threshold
- board dashboard dataset does not refresh

Operator actions:
1. inspect upstream canonical and mart quality checks
2. compare metric grain and filters against prior release
3. rollback the semantic-layer change if needed
4. document incident, impact, and corrective action

## Escalation matrix
- data engineering on-call: ingestion and orchestration incidents
- analytics engineering lead: mart and semantic metric issues
- data architect or steward: canonical model conflicts and source-authority disputes
- business owner: executive-reporting degradation or investor-priority inaccuracies

## Recovery principles
- replay from raw where possible
- avoid manual edits in canonical tables without audit trail
- preserve source evidence for every corrective action

## Backfill implementation notes
- local backfill helper: [src/orchestration/backfill.py](/Users/yasserghias/Documents/Playground/capital-raising-data-platform/src/orchestration/backfill.py)
- reconciliation queries after backfill: [sql/reconciliation.sql](/Users/yasserghias/Documents/Playground/capital-raising-data-platform/sql/reconciliation.sql)
