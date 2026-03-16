# CI/CD

## Delivery strategy
The repository follows trunk-based development with environment promotion through automated checks. The CI/CD posture is intentionally enterprise-oriented:

- lint and unit tests on every pull request
- SQL validation and lightweight contract tests before merge
- container build on main branch
- environment-specific deploy workflow with manual approval gates for production

## CI stages
1. Python dependency installation
2. static analysis and formatting checks
3. unit and integration test execution
4. SQL syntax and warehouse object validation
5. sample DAG import validation

## CD stages
1. build versioned application artifact or image
2. publish container image
3. deploy orchestrator code and configuration
4. apply dbt or SQL migration changes
5. run post-deploy smoke checks

## Promotion controls
- protected branches
- required reviewers for architecture and data model changes
- secret scanning and dependency scanning
- approval gate before production deploy

## Secrets management
No credentials should be committed. Runtime secrets belong in GitHub Actions secrets, Vault, AWS Secrets Manager, Azure Key Vault, or Databricks secret scopes depending on deployment target.
