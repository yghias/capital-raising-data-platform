-- Monitoring queries aligned to documented observability metrics.

select
    'raw_market_intel_freshness' as metric_name,
    max(extracted_at) as latest_extracted_at,
    datediff('hour', max(extracted_at), current_timestamp()) as freshness_lag_hours
from capital_markets_raw.raw_market_intel_rounds;

select
    'raw_crm_activity_freshness' as metric_name,
    max(extracted_at) as latest_extracted_at,
    datediff('hour', max(extracted_at), current_timestamp()) as freshness_lag_hours
from capital_markets_raw.raw_crm_activity;

select
    'canonical_investor_duplicates' as metric_name,
    count(*) as duplicate_groups
from (
    select canonical_investor_id
    from capital_markets_canonical.dim_investor
    group by canonical_investor_id
    having count(*) > 1
);

select
    'executive_kpi_row_count' as metric_name,
    count(*) as row_count
from capital_markets_marts.mart_exec_fundraising_kpis;
