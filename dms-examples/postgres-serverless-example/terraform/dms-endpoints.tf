# Source
resource "aws_dms_endpoint" "postgres_source" {
  endpoint_id   = "${local.app_name}-postgres-endpoint-source"
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

# Target
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