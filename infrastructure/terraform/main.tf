terraform {
  required_version = ">= 1.7.0"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "snowflake_database" {
  type        = string
  description = "Primary Snowflake database for the platform"
  default     = "CAPITAL_MARKETS"
}

locals {
  common_tags = {
    service     = "capital-raising-data-platform"
    environment = var.environment
    owner       = "data-platform"
  }
}

output "deployment_summary" {
  value = {
    database = var.snowflake_database
    tags     = local.common_tags
  }
}
