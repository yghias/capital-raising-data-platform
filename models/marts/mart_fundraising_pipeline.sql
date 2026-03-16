with rounds as (
    select *
    from {{ ref('stg_market_intel_rounds') }}
),
crm as (
    select *
    from {{ ref('stg_crm_relationship_activity') }}
)
select
    current_date as pipeline_date,
    rounds.company_name,
    rounds.round_type as active_round_type,
    count(distinct rounds.investor_name) as qualified_target_count,
    count(distinct case when crm.outcome in ('meeting_booked', 'diligence') then crm.investor_name end) as warm_investor_count,
    sum(case when crm.outcome = 'meeting_booked' then 1 else 0 end) as meetings_booked,
    sum(case when crm.outcome = 'diligence' then 1 else 0 end) as diligence_entries,
    round(div0(sum(case when crm.outcome = 'meeting_booked' then 1 else 0 end), nullif(count(distinct rounds.investor_name), 0)), 4) as meeting_conversion_rate,
    round(div0(sum(case when crm.outcome = 'diligence' then 1 else 0 end), nullif(sum(case when crm.outcome = 'meeting_booked' then 1 else 0 end), 0)), 4) as diligence_progression_rate
from rounds
left join crm
  on rounds.investor_name = crm.investor_name
group by current_date, rounds.company_name, rounds.round_type
