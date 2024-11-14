resource "aws_secretsmanager_secret" "secret_example" {
  name       = local.secret_name
  kms_key_id = aws_kms_key.common_kms_key.id

  recovery_window_in_days = 0
  tags = {
    name = local.secret_name
  }
}

resource "aws_secretsmanager_secret_version" "secret_example" {
  secret_id     = aws_secretsmanager_secret.secret_example.id
  secret_string = jsonencode(local.credentials)
}
