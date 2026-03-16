# Data Contracts

## Purpose
This document defines the minimum source contracts required for ingestion into the capital raising platform. Contract enforcement happens at landing time before source data is promoted into standardized warehouse models.

## Contract categories
- schema contract: required fields, types, and allowed nullability
- freshness contract: expected delivery cadence and lateness thresholds
- identifier contract: stable source keys or deterministic fallbacks
- semantic contract: supported enumerations and controlled vocabularies

## Source contracts

### CRM relationship activity
Required fields:
- `crm_account_id`
- `investor_name`
- `relationship_owner`
- `activity_date`
- `activity_type`
- `outcome`

Freshness:
- expected every hour during business days
- alert if delayed more than 3 hours

Contract notes:
- account and contact ids must remain stable across extracts
- deletes must be represented as tombstones or soft-delete flags

### Market intelligence rounds feed
Required fields:
- `source_record_id`
- `company_name`
- `investor_name`
- `round_type`
- `announcement_date`
- `amount_usd`

Freshness:
- expected daily by 06:00 America/Detroit
- alert if delayed more than 12 hours

Contract notes:
- round type values are mapped into enterprise taxonomy during staging
- currency normalization occurs in standardized SQL models

### Filing-derived fundraising signals
Required fields:
- `filing_id`
- `company_name`
- `filing_type`
- `filed_at`
- `signal_category`

Freshness:
- expected intraday
- alert if backlog exceeds 6 hours

Contract notes:
- filing timestamps remain in UTC until staging
- parser confidence must be stored for downstream quality review

## Enforcement model
- ingestion services validate required keys and envelope metadata
- Snowflake staging tables enforce column typing and basic nullability
- dbt tests assert accepted values, key uniqueness, and referential integrity
- reconciliation SQL compares warehouse facts to raw landing counts

## Schema drift handling
When a provider adds or changes fields:
1. raw payloads continue landing unchanged
2. the ingestion contract emits a warning event
3. standardized models are updated before the field is exposed downstream
4. canonical publish remains blocked if the change affects key identity fields
