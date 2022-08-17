resource "random_password" "master" {
  length           = 10
  special          = false
  override_special = "':/@\"\\!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "password" {
  name = "postgres-password"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id      = aws_secretsmanager_secret.password.id
  secret_string  = random_password.master.result
}

resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = aws_secretsmanager_secret.password.id
  rotation_lambda_arn = aws_lambda_function.secrete_rotation_lambda.arn

  rotation_rules {
    schedule_expression = "rate(2 days)"
  }
}

