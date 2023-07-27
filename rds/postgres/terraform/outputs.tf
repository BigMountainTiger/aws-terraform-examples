output "endpoint" {
  value = aws_db_instance.postgres.address
}

output "domain_name" {
  value = local.domain_name
}

output "username" {
  value = local.postgres-username
}

output "password" {
  value = local.postgres-pwd
}