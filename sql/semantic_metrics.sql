-- Semantic views for business-facing analytics consumers.

create or replace view capital_markets_semantic.sem_investor_priority as
select
    investor_priority_date,
    canonical_investor_id,
    display_name,
    investor_type,
    sector_alignment_bucket,
    relationship_status,
    priority_score,
    fit_score,
    relationship_score,
    signal_momentum_score,
    coverage_gap_flag
from capital_markets_marts.mart_investor_priority;

create or replace view capital_markets_semantic.sem_fundraising_pipeline as
select
    pipeline_date,
    canonical_company_id,
    company_name,
    active_round_type,
    qualified_target_count,
    warm_investor_count,
    meetings_booked,
    diligence_entries,
    meeting_conversion_rate,
    diligence_progression_rate,
    days_in_stage
from capital_markets_marts.mart_fundraising_pipeline;

create or replace view capital_markets_semantic.sem_relationship_intelligence as
select
    snapshot_date,
    canonical_company_id,
    company_name,
    canonical_investor_id,
    investor_name,
    relationship_owner,
    warm_path_count,
    highest_path_strength,
    last_touch_recency_days,
    coverage_status
from capital_markets_marts.mart_relationship_intelligence;
