with source_rows as (
    select
        source_record_id,
        payload:company_name::varchar as company_name,
        payload:investor_name::varchar as investor_name,
        payload:round_type::varchar as round_type,
        payload:announcement_date::date as announcement_date,
        payload:amount_usd::number(18,2) as amount_usd,
        'market_intel_api' as source_system,
        extracted_at
    from {{ source('raw', 'raw_market_intel_rounds') }}
)
select
    source_record_id,
    trim(company_name) as company_name,
    trim(investor_name) as investor_name,
    upper(trim(round_type)) as round_type,
    announcement_date,
    amount_usd,
    source_system,
    extracted_at as source_extracted_at
from source_rows
