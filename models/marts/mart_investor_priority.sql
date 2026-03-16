with base as (
    select *
    from {{ ref('int_investor_signal_rollup') }}
),
scored as (
    select
        current_date as investor_priority_date,
        canonical_investor_id,
        investor_name,
        total_round_signals,
        latest_signal_date,
        coalesce(round_signal_strength, 0.35) as signal_momentum_score,
        coalesce(max_relationship_strength, 0.25) as relationship_score,
        case
            when investor_name ilike '%growth%' or investor_name ilike '%capital%' then 0.90
            else 0.60
        end as fit_score,
        case
            when last_touch_date is null then 'uncovered'
            when datediff('day', last_touch_date, current_date) <= 30 then 'warm'
            when datediff('day', last_touch_date, current_date) <= 90 then 'active'
            else 'stale'
        end as relationship_status,
        case when last_touch_date is null then true else false end as coverage_gap_flag
    from base
)
select
    investor_priority_date,
    canonical_investor_id,
    investor_name as display_name,
    total_round_signals,
    latest_signal_date,
    signal_momentum_score,
    relationship_score,
    fit_score,
    relationship_status,
    coverage_gap_flag,
    round((0.45 * fit_score) + (0.35 * relationship_score) + (0.20 * signal_momentum_score), 4) as priority_score
from scored
