-- Core warehouse schema for canonical investor intelligence.

create schema if not exists capital_markets_raw;
create schema if not exists capital_markets_std;
create schema if not exists capital_markets_int;
create schema if not exists capital_markets_canonical;
create schema if not exists capital_markets_marts;
create schema if not exists capital_markets_semantic;

create or replace table capital_markets_raw.raw_market_intel_rounds (
    source_record_id varchar not null,
    source_file_name varchar,
    extracted_at timestamp_ntz not null,
    payload variant not null,
    record_checksum varchar not null
);

create or replace table capital_markets_raw.raw_crm_activity (
    source_record_id varchar not null,
    extracted_at timestamp_ntz not null,
    payload variant not null,
    record_checksum varchar not null
);

create or replace table capital_markets_std.stg_market_intel_rounds (
    source_record_id varchar not null,
    company_name varchar not null,
    investor_name varchar not null,
    round_type varchar not null,
    announcement_date date,
    amount_usd number(18,2),
    source_system varchar not null,
    load_ts timestamp_ntz default current_timestamp()
);

create or replace table capital_markets_std.stg_crm_relationship_activity (
    crm_record_id varchar not null,
    crm_account_id varchar,
    investor_name varchar not null,
    relationship_owner varchar not null,
    activity_type varchar not null,
    activity_date date not null,
    outcome varchar,
    warm_intro_path varchar,
    relationship_strength number(5,4),
    load_ts timestamp_ntz default current_timestamp()
);

create or replace table capital_markets_canonical.dim_investor (
    investor_sk bigint autoincrement,
    canonical_investor_id varchar not null,
    display_name varchar not null,
    investor_type varchar,
    headquarters_country varchar,
    aum_usd number(18,2),
    focus_sectors array,
    preferred_stages array,
    active_flag boolean default true,
    stewardship_status varchar,
    match_confidence number(5,4),
    current_record_flag boolean default true,
    effective_from_ts timestamp_ntz default current_timestamp(),
    effective_to_ts timestamp_ntz,
    primary key (investor_sk)
);

create or replace table capital_markets_canonical.dim_company (
    company_sk bigint autoincrement,
    canonical_company_id varchar not null,
    company_name varchar not null,
    sector varchar,
    sub_sector varchar,
    headquarters_country varchar,
    latest_known_valuation_usd number(18,2),
    website_domain varchar,
    active_flag boolean default true,
    primary key (company_sk)
);

create or replace table capital_markets_canonical.dim_fund (
    fund_sk bigint autoincrement,
    canonical_fund_id varchar not null,
    canonical_investor_id varchar not null,
    fund_name varchar not null,
    strategy varchar,
    vintage_year integer,
    target_size_usd number(18,2),
    status varchar,
    primary key (fund_sk)
);

create or replace table capital_markets_canonical.dim_person (
    person_sk bigint autoincrement,
    canonical_person_id varchar not null,
    person_name varchar not null,
    current_title varchar,
    current_firm_name varchar,
    email_domain varchar,
    active_flag boolean default true,
    primary key (person_sk)
);

create or replace table capital_markets_canonical.dim_signal (
    signal_sk bigint autoincrement,
    canonical_signal_id varchar not null,
    related_entity_type varchar not null,
    related_entity_id varchar not null,
    signal_category varchar not null,
    signal_strength number(5,4),
    signal_date date,
    signal_source varchar not null,
    primary key (signal_sk)
);

create or replace table capital_markets_canonical.bridge_investor_company (
    canonical_investor_id varchar not null,
    canonical_company_id varchar not null,
    relationship_type varchar not null,
    first_observed_date date,
    last_observed_date date,
    relationship_strength number(5,4)
);

create or replace table capital_markets_canonical.fact_fundraising_event (
    fundraising_event_sk bigint autoincrement,
    canonical_company_id varchar not null,
    canonical_investor_id varchar,
    round_type varchar not null,
    announcement_date date,
    amount_usd number(18,2),
    lead_investor_flag boolean,
    source_system varchar,
    source_record_id varchar,
    load_ts timestamp_ntz default current_timestamp(),
    primary key (fundraising_event_sk)
);

create or replace table capital_markets_canonical.fact_outreach_activity (
    outreach_activity_sk bigint autoincrement,
    canonical_investor_id varchar not null,
    canonical_company_id varchar,
    round_type varchar,
    relationship_owner varchar,
    activity_type varchar,
    activity_date date,
    outcome varchar,
    warm_intro_path varchar,
    relationship_strength number(5,4),
    crm_record_id varchar,
    load_ts timestamp_ntz default current_timestamp(),
    primary key (outreach_activity_sk)
);

create or replace table capital_markets_canonical.fact_investor_engagement_daily (
    engagement_date date not null,
    canonical_investor_id varchar not null,
    qualified_target_flag boolean,
    warm_path_count integer,
    active_touchpoints integer,
    latest_signal_strength number(5,4),
    priority_score number(8,4),
    primary key (engagement_date, canonical_investor_id)
);
