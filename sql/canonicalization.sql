-- Canonicalization support views for Snowflake execution.

create or replace view capital_markets_int.int_investor_name_keys as
select
    source_system,
    source_record_id,
    investor_name,
    lower(regexp_replace(investor_name, '[^a-zA-Z0-9 ]', '')) as normalized_investor_name,
    regexp_substr(lower(regexp_replace(investor_name, '[^a-zA-Z0-9 ]', '')), '^[^ ]+') as first_name_token
from (
    select
        source_system,
        source_record_id,
        payload:investor_name::varchar as investor_name
    from capital_markets_raw.raw_market_intel_rounds
);

create or replace view capital_markets_int.int_investor_entity_clusters as
with ranked as (
    select
        normalized_investor_name,
        min(source_record_id) as anchor_source_record_id,
        count(*) as observed_records
    from capital_markets_int.int_investor_name_keys
    group by normalized_investor_name
)
select
    concat('INV_', lpad(row_number() over (order by normalized_investor_name)::varchar, 6, '0')) as canonical_investor_id,
    normalized_investor_name,
    anchor_source_record_id,
    observed_records
from ranked;
