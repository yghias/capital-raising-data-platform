# Observability

## Observability model
The platform treats observability as a product capability, not an afterthought. Monitoring spans infrastructure, pipelines, data quality, and business outcomes.

## Telemetry domains

### Pipeline health
- DAG success rate
- task latency and retry counts
- freshness lag by dataset
- source extraction coverage

### Data quality
- null-rate spikes
- duplicate rate by canonical entity
- schema drift events
- referential integrity failures
- confidence distribution shifts in entity resolution

### Business reliability
- investor coverage ratio by sector
- percentage of outreach records linked to canonical investors
- volume of unmatched fundraising signals
- executive dashboard metric variance against prior day and prior week

## Alerting tiers
- P1: canonical publish blocked, executive KPI mart unavailable
- P2: critical source delayed beyond SLA, duplicate surge in top-tier investors
- P3: non-critical source failure, transient enrichment degradation

## Recommended tooling
- Airflow task metrics
- warehouse query history and cost telemetry
- Great Expectations or SQL assertions
- OpenLineage or metadata platform integration
- Grafana, Datadog, or Prometheus-based dashboards
- monitoring queries in [sql/monitoring.sql](/Users/yasserghias/Documents/Playground/capital-raising-data-platform/sql/monitoring.sql)

## Operational dashboards
- ingestion pipeline status
- canonical entity quality
- mart freshness and data quality score
- scoring service output distribution
- cost and warehouse utilization

## SLA instrumentation
- freshness is measured at raw, staging, canonical, and semantic publish checkpoints
- Airflow records scheduled start, actual start, completion time, and retry counts for every critical DAG
- executive dataset publication emits an explicit success marker only after reconciliation and semantic checks pass

## Recommended alert payload
- failing dataset or DAG identifier
- impacted downstream semantic views or dashboards
- latest successful partition or watermark
- owner and escalation path

## Repository implementation notes
- monitoring SQL lives in [sql/monitoring.sql](/Users/yasserghias/Documents/Playground/capital-raising-data-platform/sql/monitoring.sql)
- orchestration validation is implemented in [src/orchestration/sql_tasks.py](/Users/yasserghias/Documents/Playground/capital-raising-data-platform/src/orchestration/sql_tasks.py)
