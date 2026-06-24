locals {
  database_name = "lambda_awswrangler_iceberg_example_db"
}

resource "aws_glue_catalog_database" "database" {
  name = local.database_name
}