# Connect to the postgres database created in rds/postgres directory

resource "aws_dms_endpoint" "postgres_target" {
  endpoint_id   = "${local.app_name}-postgres-endpoint-target"
  endpoint_type = "target"
  engine_name   = "postgres"

  server_name   = local.db.postgres.server_name
  database_name = local.db.postgres.database_name
  username      = local.db.postgres.username
  password      = local.db.postgres.password
  port          = local.db.postgres.port

  tags = {
    Name = local.db.postgres.server_name
  }
}
