# Testing

## Testing philosophy
The testing strategy balances correctness, trust, and delivery speed. It spans code, data contracts, transformations, orchestration, and business metrics.

## Test layers

### Unit tests
- parsing and connector envelope creation
- normalization and survivorship functions
- scoring feature engineering and weight calculations

### Contract tests
- source schema expectations for APIs and files
- required fields and supported enum values
- pagination and rate-limit behavior

### Data tests
- uniqueness and not-null constraints on canonical keys
- accepted values for investor and event taxonomies
- referential integrity between facts and dimensions
- freshness tests on critical marts
- reconciliation checks between raw, staging, canonical, and mart row counts
- semantic metric tolerance checks before executive publish

### Integration tests
- end-to-end sample ingestion through scoring
- DAG import tests
- warehouse SQL compilation tests
- deployment smoke checks for required SQL and infrastructure assets

### User acceptance checks
- executive KPI reconciliation
- investor target list spot checks against steered truth sets
- relationship-intelligence path validation for priority accounts

## Release gates
- fail the pipeline if canonical keys lose uniqueness
- block publication if match confidence drops materially
- trigger manual review if investor prioritization distributions shift beyond tolerance
- prevent executive semantic refresh if reconciliation delta exceeds approved threshold
