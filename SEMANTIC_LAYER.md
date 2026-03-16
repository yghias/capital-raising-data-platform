# Semantic Layer

## Purpose
Semantic views sit above the marts layer and provide stable, business-owned definitions for executive reporting, fundraising operations, and investor intelligence workflows.

## Semantic datasets

### `sem_investor_priority`
Grain:
- one row per investor per reporting date

Primary consumers:
- investor coverage dashboard
- CRM targeting export
- partner review pack

Core metrics:
- `priority_score`
- `relationship_status`
- `signal_momentum_score`
- `fit_score`
- `coverage_gap_flag`

### `sem_fundraising_pipeline`
Grain:
- one row per company and active round

Primary consumers:
- fundraising operating review
- finance planning
- executive leadership dashboard

Core metrics:
- `qualified_target_count`
- `warm_investor_count`
- `meeting_conversion_rate`
- `diligence_progression_rate`
- `days_in_stage`

### `sem_relationship_intelligence`
Grain:
- one row per company, investor, and relationship path

Primary consumers:
- relationship intelligence workflow
- capital formation team
- partner introductions desk

Core metrics:
- `warm_path_count`
- `highest_path_strength`
- `last_touch_recency_days`
- `coverage_owner`

## Metric governance
- semantic definitions are versioned and reviewed jointly by analytics engineering and business owners
- warehouse marts may evolve, but semantic columns should remain stable unless a formal metric change is approved
- executive metrics require reconciliation against prior period outputs before production publish
