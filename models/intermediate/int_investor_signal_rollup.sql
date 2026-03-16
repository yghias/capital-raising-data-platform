with round_signals as (
    select
        entity_map.canonical_investor_id,
        rounds.investor_name,
        count(*) as total_round_signals,
        max(rounds.announcement_date) as latest_signal_date,
        avg(case
            when rounds.round_type in ('SERIES A', 'SERIES B', 'GROWTH') then 0.85
            else 0.55
        end) as round_signal_strength
    from {{ ref('stg_market_intel_rounds') }} rounds
    join {{ ref('int_investor_entity_map') }} entity_map
      on lower(regexp_replace(rounds.investor_name, '[^a-zA-Z0-9 ]', '')) = entity_map.normalized_investor_name
    group by entity_map.canonical_investor_id, rounds.investor_name
),
crm_rollup as (
    select
        entity_map.canonical_investor_id,
        max(activity_date) as last_touch_date,
        count(*) as total_touchpoints,
        max(relationship_strength) as max_relationship_strength
    from {{ ref('stg_crm_relationship_activity') }} crm
    join {{ ref('int_investor_entity_map') }} entity_map
      on lower(regexp_replace(crm.investor_name, '[^a-zA-Z0-9 ]', '')) = entity_map.normalized_investor_name
    group by entity_map.canonical_investor_id
)
select
    round_signals.canonical_investor_id,
    round_signals.investor_name,
    round_signals.total_round_signals,
    round_signals.latest_signal_date,
    round_signals.round_signal_strength,
    crm_rollup.last_touch_date,
    crm_rollup.total_touchpoints,
    crm_rollup.max_relationship_strength
from round_signals
left join crm_rollup
  on round_signals.canonical_investor_id = crm_rollup.canonical_investor_id
