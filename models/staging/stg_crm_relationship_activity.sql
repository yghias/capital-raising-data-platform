with source_rows as (
    select
        source_record_id as crm_record_id,
        payload:crm_account_id::varchar as crm_account_id,
        payload:investor_name::varchar as investor_name,
        payload:relationship_owner::varchar as relationship_owner,
        payload:activity_type::varchar as activity_type,
        payload:activity_date::date as activity_date,
        payload:outcome::varchar as outcome,
        payload:warm_intro_path::varchar as warm_intro_path,
        payload:relationship_strength::number(5,4) as relationship_strength
    from {{ source('raw', 'raw_crm_activity') }}
)
select
    crm_record_id,
    crm_account_id,
    trim(investor_name) as investor_name,
    trim(relationship_owner) as relationship_owner,
    lower(trim(activity_type)) as activity_type,
    activity_date,
    lower(trim(outcome)) as outcome,
    warm_intro_path,
    relationship_strength
from source_rows
