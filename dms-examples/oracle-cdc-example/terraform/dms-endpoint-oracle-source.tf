locals {
  cdc_user_name     = "CDCUSER"
  cdc_user_password = "password-123"
}

resource "aws_dms_endpoint" "oracle_source" {
  endpoint_id   = "${local.app_name}-oracle-endpoint-source"
  endpoint_type = "source"
  engine_name   = "oracle"

  server_name   = local.db.oracle.server_name
  database_name = local.db.oracle.database_name
  username      = local.cdc_user_name
  password      = local.cdc_user_password
  port          = local.db.oracle.port

  tags = {
    Name = local.db.oracle.server_name
  }
}
