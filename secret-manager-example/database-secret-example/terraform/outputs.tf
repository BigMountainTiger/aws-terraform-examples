output "secret-name" {
  value = aws_secretsmanager_secret.password.name
}


output "db-address" {
  value = aws_db_instance.postgres_example.address
}

output "jdbc-connect-string" {
  value = "jdbc:postgresql://${aws_db_instance.postgres_example.address}:5432/${local.db_name}"
}

output "login-info" {
  value = {
    username = local.username
    password = nonsensitive(aws_secretsmanager_secret_version.password.secret_string)
  }
}
