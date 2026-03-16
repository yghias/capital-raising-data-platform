-- Reconciliation checks between raw, staging, canonical, and mart layers.

with raw_market as (
    select count(*) as row_count
    from capital_markets_raw.raw_market_intel_rounds
),
staged_market as (
    select count(*) as row_count
    from capital_markets_std.stg_market_intel_rounds
),
canonical_events as (
    select count(*) as row_count
    from capital_markets_canonical.fact_fundraising_event
)
select
    'market_round_row_count' as reconciliation_name,
    raw_market.row_count as raw_count,
    staged_market.row_count as staged_count,
    canonical_events.row_count as canonical_count,
    abs(raw_market.row_count - staged_market.row_count) as raw_vs_staged_delta,
    abs(staged_market.row_count - canonical_events.row_count) as staged_vs_canonical_delta
from raw_market
cross join staged_market
cross join canonical_events;

with crm_raw as (
    select count(*) as row_count
    from capital_markets_raw.raw_crm_activity
),
crm_staged as (
    select count(*) as row_count
    from capital_markets_std.stg_crm_relationship_activity
),
crm_fact as (
    select count(*) as row_count
    from capital_markets_canonical.fact_outreach_activity
)
select
    'crm_activity_row_count' as reconciliation_name,
    crm_raw.row_count as raw_count,
    crm_staged.row_count as staged_count,
    crm_fact.row_count as canonical_count,
    abs(crm_raw.row_count - crm_staged.row_count) as raw_vs_staged_delta,
    abs(crm_staged.row_count - crm_fact.row_count) as staged_vs_canonical_delta
from crm_raw
cross join crm_staged
cross join crm_fact;
