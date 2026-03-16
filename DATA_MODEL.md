# Data Model

## Modeling philosophy
The platform uses a three-tier modeling strategy:

1. Conceptual model for shared business language
2. Logical model for domain relationships and conformed entities
3. Physical model for warehouse implementation, performance, and governance

The architecture is entity-centric rather than source-centric because investor intelligence use cases depend on coherent, cross-source identity.

## Conceptual model
Core business entities:

- Investor: an institution or individual allocator, VC, PE, family office, strategic investor, or LP
- Fund: an investment vehicle associated with a manager and strategy
- Company: operating company, portfolio company, or fundraising issuer
- Person: partner, executive, board member, founder, advisor, or relationship owner
- Fundraising Event: round, roadshow milestone, meeting, diligence stage, or close event
- Relationship: interaction, affiliation, prior investment, board overlap, referral, or CRM touchpoint
- Signal: news, filing, hiring, market movement, thesis alignment, or trigger event

## Logical model

### Canonical domains
- `dim_investor`
- `dim_fund`
- `dim_company`
- `dim_person`
- `dim_relationship`
- `dim_signal`
- `fact_fundraising_event`
- `fact_outreach_activity`
- `fact_investor_engagement`

### Key relationship patterns
- one investor can manage many funds
- one company can participate in many fundraising events over time
- one person can hold multiple roles across investors, funds, and companies
- relationships can be direct or inferred from historical activity, shared boards, or syndication history
- signals can attach to companies, investors, funds, or people and decay over time

## Entity resolution and canonical records
Entity resolution is required because the same real-world entity may appear with conflicting names, identifiers, or metadata across multiple datasets.

### Matching strategy
- deterministic keys: website domain, SEC CIK, CRM account id, known vendor ids
- normalized text keys: cleaned legal name, aliases, acronym handling
- contextual similarity: HQ geography, industry, AUM range, partner roster, portfolio overlap
- relationship corroboration: same associated people, board members, or prior rounds

### Survivorship strategy
- authoritative source precedence by attribute
- freshness weighting for volatile fields such as employee count and status
- steward override for high-value entities
- confidence scoring retained for transparency

### Canonical entity payload example
```json
{
  "canonical_investor_id": "INV_0001842",
  "display_name": "North Harbor Growth Partners",
  "investor_type": "Growth Equity",
  "headquarters_country": "United States",
  "website_domain": "northharborgp.com",
  "aum_usd": 4200000000,
  "focus_sectors": ["Fintech", "Vertical SaaS", "Data Infrastructure"],
  "source_attribution": [
    {"source_system": "crm", "source_record_id": "SF-ACCT-2942"},
    {"source_system": "market_feed", "source_record_id": "PB-99812"}
  ],
  "match_confidence": 0.97,
  "stewardship_status": "trusted"
}
```

## Physical model in the warehouse

### Raw layer
- append-only tables or object storage payload archives
- one table or partition family per source feed
- minimal transformation beyond envelope metadata

### Standardized layer
- source-aligned typed tables
- normalized dates, currencies, booleans, taxonomy fields
- technical duplicate removal

### Canonical layer
- conformed dimensions and facts
- bridge tables for many-to-many relationships
- lineage and source attribution columns
- current-state snapshots plus history where analytically required

### Mart layer
- dimensional star schemas or wide marts depending on access patterns
- precomputed scorecards for targeting and prioritization
- executive-friendly metric grain documented in semantic layer definitions

## Grain definitions
- `fact_fundraising_event`: one record per fundraising milestone event per company and round
- `fact_outreach_activity`: one record per investor-facing touchpoint
- `fact_investor_engagement`: one record per investor and measurement period
- `dim_relationship`: one record per unique relationship edge with type and confidence

## Data domains and authoritative sources
- investor legal and CRM ownership attributes: CRM and stewardship workflow
- fund strategy and vintage metadata: licensed market intelligence feed
- company financing history: licensed feed plus public filings reconciliation
- contact and meeting history: CRM and calendar integration
- executive KPI metrics: curated semantic layer, not directly from source systems

## Dimensional modeling guidance
- use surrogate keys for warehouse joins
- preserve natural keys and vendor ids for traceability
- model slowly changing attributes where longitudinal analysis matters
- separate descriptive dimensions from volatile score outputs
- avoid embedding business logic directly in dashboards; publish curated marts instead

## Physical considerations
- cluster or partition large facts by event date and canonical entity id
- snapshot canonical dimensions where investor or company states change meaningfully over time
- maintain a match review queue for confidence bands below publish thresholds
