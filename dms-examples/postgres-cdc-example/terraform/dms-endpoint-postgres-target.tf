# Connect to the postgres database created in rds/postgres directory

resource "aws_dms_endpoint" "postgres_target" {
  endpoint_id   = "${local.app_name}-postgres-endpoint-target"
  endpoint_type = "target"
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
