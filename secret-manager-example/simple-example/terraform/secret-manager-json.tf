locals {
  json_secret = {
    secret_name        = "a_simple_json_secret"
    secret_description = "A simple json secret"

    secret_string = jsonencode({
      value_1 = "value_1 value"
      value_2 = "value_2 value"
    })
  }
}

# Json
resource "aws_secretsmanager_secret" "simple_json_secret" {
  name        = local.json_secret.secret_name
  description = local.json_secret.secret_description

  recovery_window_in_days = 0

  # It looks like tags_all not taking effect at all
  tags = {
    Name = "simple_json_secret"
    Note = "It looks like tags_all not taking effect at all"
  }
}

resource "aws_secretsmanager_secret_version" "simple_json_secret" {
  secret_id     = aws_secretsmanager_secret.simple_json_secret.id
  secret_string = local.json_secret.secret_string
}
