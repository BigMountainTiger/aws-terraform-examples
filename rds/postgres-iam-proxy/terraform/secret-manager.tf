resource "aws_secretsmanager_secret" "rds_secret" {
  name = "${local.app_name}-rds-secret"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = aws_secretsmanager_secret.rds_secret.id

  secret_string = jsonencode({
    username = local.postgres_username
    password = local.postgres_password
  })
}
