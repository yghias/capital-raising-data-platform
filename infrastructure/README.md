# Infrastructure

## Scope
This folder contains deployment-oriented assets and configuration notes for the platform runtime. The preferred target architecture is:

- Snowflake for warehouse and semantic serving
- Airflow for orchestration
- object storage for raw landing and replay
- GitHub Actions for CI/CD
- optional Neo4j for graph serving

## Deployment boundaries
- ingestion services write raw files or stage-ready extracts to object storage
- Snowflake handles standardized, intermediate, canonical, mart, and semantic layers
- Airflow schedules ingestion, dbt runs, reconciliation checks, and publish notifications

## Environment assumptions
- separate Snowflake databases or schemas per environment
- dedicated Airflow deployment per environment or clearly segmented DAG runtime
- isolated secrets by environment
- network controls between ingestion workers, Snowflake, and provider endpoints
