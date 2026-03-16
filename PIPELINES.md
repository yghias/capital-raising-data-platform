# Pipelines

## Pipeline design principles
- idempotent by default
- source-aware and contract-tested
- observable at task, dataset, and business-SLA levels
- restartable from raw landing without manual repair
- quality-gated before canonical publish

## Pipeline layers

### Ingestion pipelines
Responsible for extracting data from:

- REST APIs for CRM, market intelligence, and enrichment providers
- scheduled CSV or parquet drops from licensed feeds
- public filings crawlers and parsers
- event and news signal listeners

Outputs are raw landing objects or tables with ingestion metadata and record hashes.

### Standardization pipelines
These pipelines:

- flatten nested payloads into source-aligned tables
- standardize field names, time zones, currencies, and taxonomies
- map source enumerations into enterprise vocabularies
- reject schema-breaking payloads into quarantine streams

### Canonicalization pipelines
These pipelines perform:

- entity matching and clustering
- survivorship and golden-record assembly
- relationship edge generation
- source attribution tracking
- publish only on quality and confidence thresholds

### Analytical marts pipelines
These pipelines derive:

- investor targeting views
- outreach prioritization scorecards
- fundraising pipeline funnel metrics
- relationship network coverage metrics
- board and executive KPI packs

## Scheduling model
- hourly for CRM deltas and news-triggered signals
- daily for most licensed market intelligence feeds
- daily or intraday for canonical publish depending on stewardship queue depth
- daily for executive KPI marts
- weekly retraining or recalibration for scoring models

## Orchestration patterns
Airflow manages dependency graphs, retries, SLAs, backfills, and task ownership. A typical DAG structure:

1. extract source payloads
2. validate schema and contracts
3. load standardized tables
4. run canonical matching
5. publish marts
6. execute data quality suite
7. notify operators if thresholds fail

## Failure domains
- ingestion failure: source unavailable, auth failure, schema drift
- standardization failure: parsing or taxonomy mapping issue
- canonical failure: confidence collapse, duplicate surge, survivorship ambiguity
- mart failure: referential integrity break, metric variance anomaly

## Replay strategy
- retain raw payload archives for replay
- stamp batch ids and deterministic hashes
- rebuild standardized and canonical layers from raw if matching logic changes
- support backfills by source and date partition

## Performance considerations
- parallelize source extraction by endpoint or tenant
- push heavy joins into warehouse or Spark engine
- cache reference mappings for taxonomy harmonization
- avoid reprocessing unchanged raw records using hashes and watermarks

## Example Airflow task groups
- `extract_market_data`
- `extract_crm`
- `standardize_entities`
- `resolve_canonical_entities`
- `publish_relationship_graph`
- `build_analytics_marts`
- `run_quality_and_alerting`
