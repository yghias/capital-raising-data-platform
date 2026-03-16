# Security

## Security posture
This platform handles commercially sensitive relationship intelligence and potentially personal contact data. Security design therefore emphasizes least privilege, environment isolation, and auditable access.

## Key controls
- role-based access to warehouse schemas and dashboards
- row- or column-level restrictions for sensitive CRM attributes
- encrypted transport for source integrations
- secret rotation and centralized secret management
- PII minimization in derived marts and notebooks
- audit logging for administrative and data access events

## Data classification
- public: public filing metadata, non-sensitive taxonomy references
- internal: operational metrics, non-sensitive pipeline data
- confidential: investor relationships, meeting history, proprietary scoring
- restricted: personal contact data, notes, and sensitive diligence artifacts

## Application security
- validate inbound API contracts
- sanitize untrusted text before persistence
- dependency scanning in CI
- signed container images where supported

## Warehouse security
- separate service roles for ingestion, transformation, and consumption
- restricted access to raw landing schemas
- curated views for business users instead of broad table access
- data masking policies for contact-level PII
