with candidate_names as (
    select investor_name, source_record_id
    from {{ ref('stg_market_intel_rounds') }}

    union all

    select investor_name, crm_record_id as source_record_id
    from {{ ref('stg_crm_relationship_activity') }}
),
normalized as (
    select
        investor_name,
        source_record_id,
        lower(regexp_replace(investor_name, '[^a-zA-Z0-9 ]', '')) as normalized_investor_name
    from candidate_names
),
clustered as (
    select
        normalized_investor_name,
        min(source_record_id) as anchor_source_record_id,
        count(*) as observed_records
    from normalized
    group by normalized_investor_name
)
select
    concat('INV_', lpad(row_number() over (order by normalized_investor_name)::varchar, 6, '0')) as canonical_investor_id,
    normalized_investor_name,
    anchor_source_record_id,
    observed_records
from clustered
