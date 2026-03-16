# Architectural Decisions

## ADR-001: Canonical model before reporting marts
The platform invests in a conformed canonical layer instead of mapping each source directly into dashboards. This adds upfront complexity but materially improves reuse, trust, and cross-functional consistency.

## ADR-002: Warehouse-first core with optional graph projection
Snowflake or Databricks remains the analytical system of record. Neo4j is optional and used only where graph traversal materially improves relationship intelligence use cases.

## ADR-003: Airflow for orchestration
Airflow is chosen because the platform requires dependency graphs, SLAs, retries, backfills, and operational ownership patterns across ingestion, canonical publish, and mart refresh workflows.

## ADR-004: SQL and dbt-style transformations for transparency
Most curated modeling logic is expressed in SQL so finance, analytics engineering, and data engineering stakeholders can review and govern metric logic collaboratively.

## ADR-005: Confidence-aware entity resolution
Canonical publish logic explicitly tracks match confidence and routes ambiguous cases into stewardship. Hiding ambiguity would create false precision in investor targeting and executive reporting.
