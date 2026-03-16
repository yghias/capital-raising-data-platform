# Delivery Plan

## Objective
Establish a governed Snowflake-first platform codebase for capital-raising intelligence with documented architecture, SQL-led warehouse modeling, Airflow orchestration patterns, and operational controls.

## Delivery sequence
1. Define platform boundaries, source contracts, and target warehouse architecture.
2. Implement source landing, standardized staging, canonical entity conformance, and analytical marts.
3. Publish semantic datasets, reconciliation queries, data quality checks, and KPI definitions.
4. Add CI/CD, deployment, observability, security, and runbook documentation.
5. Maintain sample data and notebooks for local validation of platform logic.

## Design principles
- favor layered architecture: raw, staging, intermediate, canonical, marts, semantic
- keep business logic in SQL where warehouse execution is the natural system boundary
- keep Python focused on ingestion, orchestration, utilities, and ML-specific flows
- retain operational metadata, source attribution, and publish controls in every critical path

## Completion criteria
- critical source contracts and SLAs are documented
- canonical and mart layers have explicit quality checks
- repository structure reflects real platform ownership boundaries
- every folder contains meaningful content or is removed
