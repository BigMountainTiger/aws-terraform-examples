locals {
  text_secret = {
    secret_name        = "a_simple_text_secret"
    secret_description = "A simple text secret"

    secret_string = "The simple secret string value"
  }
}

# Text
resource "aws_secretsmanager_secret" "simple_text_secret" {
  name        = local.text_secret.secret_name
  description = local.text_secret.secret_description

  recovery_window_in_days = 0

  tags = {
    Name = "simple_text_secret"
  }
}

resource "aws_secretsmanager_secret_version" "simple_text_secret" {
  secret_id     = aws_secretsmanager_secret.simple_text_secret.id
  secret_string = local.text_secret.secret_string
}

