locals {
  db_credential_param_name = "/database/credentials"
}

resource "aws_ssm_parameter" "parameter" {
  name        = local.db_credential_param_name
  description = local.db_credential_param_name
  type        = "String"
  value       = jsonencode(var.parameter_value)
}
