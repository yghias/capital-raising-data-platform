with crm as (
    select *
    from {{ ref('stg_crm_relationship_activity') }}
),
entity_map as (
    select *
    from {{ ref('int_investor_entity_map') }}
)
select
    current_date as snapshot_date,
    entity_map.canonical_investor_id,
    crm.investor_name,
    max(crm.relationship_owner) as relationship_owner,
    count_if(crm.warm_intro_path is not null) as warm_path_count,
    max(coalesce(crm.relationship_strength, 0.25)) as highest_path_strength,
    datediff('day', max(crm.activity_date), current_date) as last_touch_recency_days,
    case
        when max(crm.activity_date) is null then 'uncovered'
        when datediff('day', max(crm.activity_date), current_date) <= 45 then 'covered'
        else 'stale'
    end as coverage_status
from crm
join entity_map
  on lower(regexp_replace(crm.investor_name, '[^a-zA-Z0-9 ]', '')) = entity_map.normalized_investor_name
group by current_date, entity_map.canonical_investor_id, crm.investor_name
