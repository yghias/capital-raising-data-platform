# Governance

## Governance objectives
- define authoritative sources for critical attributes
- preserve lineage from source payload to business metric
- manage entity stewardship and confidence-based review
- enforce access controls for sensitive relationship and contact data
- maintain a common business glossary across platform consumers

## Governance domains

### Metadata and catalog
Each curated dataset should be registered with:

- business owner
- technical owner
- data steward
- refresh cadence
- schema contract
- SLA and quality thresholds
- downstream consumers

### Authoritative source model
Attribute-level source precedence is more reliable than table-level precedence. Example:

- investor relationship owner: CRM
- investor AUM range: licensed market intelligence feed
- filing date and form type: SEC
- executive reporting metric definitions: semantic layer specification

### Stewardship workflow
Low-confidence matches, source conflicts, and high-value exceptions are routed to a stewardship queue. Stewards can:

- merge or split entity clusters
- override survivorship outputs
- define alias rules
- suppress low-quality sources

### Business glossary
Critical business terms should be versioned and published:

- qualified investor target
- warm relationship
- outreach readiness
- active fundraising round
- investor coverage ratio
- executive pipeline confidence

## Lineage expectations
- ingestion lineage from source endpoint or file to raw landing object
- transformation lineage through standardization and canonicalization steps
- mart lineage from canonical tables to business metrics
- dashboard lineage from semantic views to board-facing visuals

## Data retention and privacy
- retain raw payloads based on contractual and regulatory obligations
- minimize storage of unnecessary personal data
- mask or restrict PII fields in lower environments
- log access to sensitive contact, meeting, and relationship data

## Governance operating cadence
- weekly data quality and stewardship review
- monthly metric-definition review with finance and fundraising leadership
- quarterly source rationalization and cost-value assessment
