# Connect to the postgres database created in rds/postgres directory

locals {
  db = {
    server_name   = "postgres.bigmountaintiger.com"
    database_name = "experiment"
    username      = "postgres"
    password      = "password-123"
    port          = 5432
  }
}

resource "aws_dms_endpoint" "postgres" {
  endpoint_id   = "${local.app_name}-postgres-endpoint"
  endpoint_type = "source"
  engine_name   = "postgres"

  server_name   = local.db.server_name
  database_name = local.db.database_name
  username      = local.db.username
  password      = local.db.password
  port          = local.db.port

  tags = {
    Name = local.db.server_name
  }
}
