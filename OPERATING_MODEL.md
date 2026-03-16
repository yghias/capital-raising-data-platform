# Operating Model

## Service boundaries
- ingestion services own source extraction, raw persistence, and contract validation
- warehouse modeling owns staging, intermediate conformance, canonical models, and marts
- analytics engineering owns semantic views, BI contracts, and metric reconciliation
- platform engineering owns Airflow runtime, CI/CD, secrets, and deploy automation
- data stewardship owns low-confidence entity review and source-authority exceptions

## Environment model
- `dev`: integration and model development with masked or synthetic data
- `staging`: production-like workflow validation and release candidate testing
- `prod`: governed datasets used for business operations and executive reporting

## Core service-level objectives
- CRM relationship staging freshness: 3 hours
- market intelligence staging freshness: 12 hours
- canonical publish completion: by 07:30 America/Detroit on business days
- executive KPI mart completion: by 08:00 America/Detroit on business days
- investor priority publish availability: 99.5 percent monthly

## Publish gates
- raw ingestion completed for required critical sources
- staging contract checks passed
- canonical uniqueness and survivorship tests passed
- reconciliation variance within approved tolerance
- semantic metrics validated against prior run thresholds

## Change management
- SQL model changes require peer review from analytics engineering or data engineering
- canonical model changes require architecture review
- metric definition changes require documented approval from the consuming business owner
- production deployment requires CI success and environment approval
