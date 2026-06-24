# Warehouse
resource "snowflake_warehouse" "dbt_dev" {
  name           = "WH_DBT_DEV"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}

# Database
resource "snowflake_database" "bank_dev" {
  name = "BANK_DEV"
}

# Schemas
resource "snowflake_schema" "staging" {
  database = snowflake_database.bank_dev.name
  name     = "STAGING"
}

resource "snowflake_schema" "credit" {
  database = snowflake_database.bank_dev.name
  name     = "CREDIT"
}

resource "snowflake_schema" "customer" {
  database = snowflake_database.bank_dev.name
  name     = "CUSTOMER"
}

resource "snowflake_schema" "finance" {
  database = snowflake_database.bank_dev.name
  name     = "FINANCE"
}

resource "snowflake_schema" "snapshots" {
  database = snowflake_database.bank_dev.name
  name     = "SNAPSHOTS"
}

# Roles
resource "snowflake_account_role" "transformer" {
  name = "TRANSFORMER_ROLE"
}

resource "snowflake_account_role" "reporter" {
  name = "REPORTER_ROLE"
}
