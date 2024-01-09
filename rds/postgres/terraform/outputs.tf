output "endpoint" {
  value = aws_db_instance.postgres.address
}

output "domain_name" {
  value = local.domain_name
}

output "database_credentials" {
  value = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.postgres.secret_string))
}
