-- Data quality and integrity assertions.

-- Canonical investors must be unique.
select canonical_investor_id, count(*) as duplicate_count
from capital_markets_canonical.dim_investor
group by canonical_investor_id
having count(*) > 1;

-- Fundraising events should not exist without a company.
select *
from capital_markets_canonical.fact_fundraising_event
where canonical_company_id is null;

-- Outreach activities must reference a canonical investor.
select a.*
from capital_markets_canonical.fact_outreach_activity a
left join capital_markets_canonical.dim_investor i
    on a.canonical_investor_id = i.canonical_investor_id
where i.canonical_investor_id is null;

-- Match confidence should remain above operational threshold for trusted records.
select *
from capital_markets_canonical.dim_investor
where stewardship_status = 'trusted'
  and match_confidence < 0.85;

-- Priority marts should publish one row per investor per day.
select investor_priority_date, canonical_investor_id, count(*) as duplicate_count
from capital_markets_marts.mart_investor_priority
group by investor_priority_date, canonical_investor_id
having count(*) > 1;

-- Fundraising pipeline conversion rates must remain between 0 and 1.
select *
from capital_markets_marts.mart_fundraising_pipeline
where meeting_conversion_rate < 0
   or meeting_conversion_rate > 1
   or diligence_progression_rate < 0
   or diligence_progression_rate > 1;

-- Relationship intelligence coverage should not produce null investor ids.
select *
from capital_markets_marts.mart_relationship_intelligence
where canonical_investor_id is null;
