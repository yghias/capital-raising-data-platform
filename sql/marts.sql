-- Analytical marts for investor targeting, relationship intelligence, and fundraising operations.

create or replace view capital_markets_marts.mart_investor_priority as
with investor_activity as (
    select
        canonical_investor_id,
        count(*) as total_rounds_observed,
        max(announcement_date) as latest_round_date,
        avg(amount_usd) as avg_check_size_usd
    from capital_markets_canonical.fact_fundraising_event
    group by canonical_investor_id
),
relationship_rollup as (
    select
        canonical_investor_id,
        max(activity_date) as last_touch_date,
        count(*) as total_touchpoints,
        max(relationship_owner) as relationship_owner
    from capital_markets_canonical.fact_outreach_activity
    group by canonical_investor_id
),
signal_rollup as (
    select
        related_entity_id as canonical_investor_id,
        max(signal_strength) as latest_signal_strength,
        avg(signal_strength) as avg_signal_strength
    from capital_markets_canonical.dim_signal
    where related_entity_type = 'investor'
    group by related_entity_id
),
base as (
    select
        current_date as investor_priority_date,
        i.canonical_investor_id,
        i.display_name,
        i.investor_type,
        i.focus_sectors,
        i.preferred_stages,
        a.total_rounds_observed,
        a.avg_check_size_usd,
        r.relationship_owner,
        r.last_touch_date,
        r.total_touchpoints,
        datediff('day', r.last_touch_date, current_date) as last_touch_recency_days,
        coalesce(s.latest_signal_strength, 0.35) as signal_momentum_score,
        case
            when array_contains('FINTECH'::variant, i.focus_sectors)
              or array_contains('DATA INFRASTRUCTURE'::variant, i.focus_sectors) then 1.0
            else 0.55
        end as fit_score,
        case
            when r.last_touch_date is null then 0.25
            when datediff('day', r.last_touch_date, current_date) <= 30 then 0.95
            when datediff('day', r.last_touch_date, current_date) <= 90 then 0.70
            else 0.40
        end as relationship_score
    from capital_markets_canonical.dim_investor i
    left join investor_activity a
        on i.canonical_investor_id = a.canonical_investor_id
    left join relationship_rollup r
        on i.canonical_investor_id = r.canonical_investor_id
    left join signal_rollup s
        on i.canonical_investor_id = s.canonical_investor_id
)
select
    investor_priority_date,
    canonical_investor_id,
    display_name,
    investor_type,
    focus_sectors,
    preferred_stages,
    total_rounds_observed,
    avg_check_size_usd,
    relationship_owner,
    last_touch_date,
    total_touchpoints,
    last_touch_recency_days,
    signal_momentum_score,
    fit_score,
    relationship_score,
    case
        when last_touch_date is null then 'uncovered'
        when last_touch_recency_days <= 30 then 'warm'
        when last_touch_recency_days <= 90 then 'active'
        else 'stale'
    end as relationship_status,
    case
        when fit_score = 1.0 then 'core'
        else 'adjacent'
    end as sector_alignment_bucket,
    case when last_touch_date is null then true else false end as coverage_gap_flag,
    round((0.45 * fit_score) + (0.35 * relationship_score) + (0.20 * signal_momentum_score), 4) as priority_score
from base;

create or replace view capital_markets_marts.mart_fundraising_pipeline as
select
    current_date as pipeline_date,
    c.canonical_company_id,
    c.company_name,
    e.round_type as active_round_type,
    count(distinct e.canonical_investor_id) as qualified_target_count,
    count(distinct case when a.outcome in ('meeting_booked', 'diligence') then a.canonical_investor_id end) as warm_investor_count,
    sum(case when a.outcome = 'meeting_booked' then 1 else 0 end) as meetings_booked,
    sum(case when a.outcome = 'diligence' then 1 else 0 end) as diligence_entries,
    sum(case when a.outcome = 'pass' then 1 else 0 end) as investor_passes,
    round(div0(sum(case when a.outcome = 'meeting_booked' then 1 else 0 end), nullif(count(distinct e.canonical_investor_id), 0)), 4) as meeting_conversion_rate,
    round(div0(sum(case when a.outcome = 'diligence' then 1 else 0 end), nullif(sum(case when a.outcome = 'meeting_booked' then 1 else 0 end), 0)), 4) as diligence_progression_rate,
    datediff('day', min(e.announcement_date), current_date) as days_in_stage
from capital_markets_canonical.fact_fundraising_event e
join capital_markets_canonical.dim_company c
    on e.canonical_company_id = c.canonical_company_id
left join capital_markets_canonical.fact_outreach_activity a
    on e.canonical_company_id = a.canonical_company_id
   and e.round_type = a.round_type
group by current_date, c.canonical_company_id, c.company_name, e.round_type;

create or replace view capital_markets_marts.mart_relationship_intelligence as
select
    current_date as snapshot_date,
    a.canonical_company_id,
    c.company_name,
    a.canonical_investor_id,
    i.display_name as investor_name,
    max(a.relationship_owner) as relationship_owner,
    count_if(a.warm_intro_path is not null) as warm_path_count,
    max(coalesce(a.relationship_strength, 0.25)) as highest_path_strength,
    datediff('day', max(a.activity_date), current_date) as last_touch_recency_days,
    case
        when max(a.activity_date) is null then 'uncovered'
        when datediff('day', max(a.activity_date), current_date) <= 45 then 'covered'
        else 'stale'
    end as coverage_status
from capital_markets_canonical.fact_outreach_activity a
join capital_markets_canonical.dim_investor i
    on a.canonical_investor_id = i.canonical_investor_id
left join capital_markets_canonical.dim_company c
    on a.canonical_company_id = c.canonical_company_id
group by current_date, a.canonical_company_id, c.company_name, a.canonical_investor_id, i.display_name;

create or replace view capital_markets_marts.mart_exec_fundraising_kpis as
select
    current_date as snapshot_date,
    count(distinct canonical_company_id) as active_companies,
    sum(qualified_target_count) as total_qualified_targets,
    sum(warm_investor_count) as total_warm_investors,
    sum(meetings_booked) as total_meetings_booked,
    avg(meeting_conversion_rate) as avg_meeting_conversion_rate,
    avg(diligence_progression_rate) as avg_diligence_progression_rate
from capital_markets_marts.mart_fundraising_pipeline;
