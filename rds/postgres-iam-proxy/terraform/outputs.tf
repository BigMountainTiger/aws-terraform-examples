output "endpoint" {
  value = {
    postgres_server   = local.domain_name
    db_name           = local.db_name
    postgres_username = local.postgres_username
    postgres_password = local.postgres_password
  }
}

output "db_connect_role" {
  value = aws_iam_role.db_connect_role.arn
}
