# API Integrations

## Integration strategy
The platform integrates with a mix of vendor APIs, internal APIs, licensed batch feeds, and public domain data. The architecture favors thin, testable connectors that emit normalized envelopes before downstream transformation.

## Representative source integrations

### Market intelligence APIs
- company profiles
- funding round history
- investor activity
- fund manager metadata
- leadership and board relationships

### CRM systems
- accounts and contacts
- meetings, tasks, and notes
- pipeline stages
- relationship owners and coverage model

### Public domain sources
- SEC filings and filing metadata
- press releases and newsroom feeds
- company websites and leadership pages

### Internal systems
- fundraising tracker
- diligence workflow tools
- outreach sequencing applications
- portfolio and board reporting datasets

## Integration design standards
- every connector emits a consistent envelope with source, extraction timestamp, payload, and checksum
- authentication material is externalized via environment variables or secret managers
- pagination and rate-limit handling are explicit and instrumented
- schema contracts are validated at ingress to surface drift early
- source-specific retries are bounded and observable

## Source envelope example
```json
{
  "source_system": "crm_salesforce",
  "entity_type": "account",
  "source_record_id": "0018Y00002abcdeQAA",
  "extracted_at": "2026-03-15T11:30:00Z",
  "checksum": "b7a8f65b2e8d",
  "payload": {
    "Name": "North Harbor Growth Partners",
    "Website": "https://northharborgp.com",
    "OwnerId": "0058Y00000xyz12QAA"
  }
}
```

## Rate limit and resilience patterns
- token-bucket aware pagination loops
- checkpointing with last-success watermarks
- dead-letter queues for non-conforming records
- circuit-breaker behavior for repeated upstream failures

## Canonical mapping priorities
- CRM is authoritative for relationship ownership and internal coverage
- licensed feeds are authoritative for market history and fund metadata unless overridden by stewardship
- public filings are authoritative for disclosed legal events and filings chronology
- signal sources are advisory and decay over time unless corroborated
