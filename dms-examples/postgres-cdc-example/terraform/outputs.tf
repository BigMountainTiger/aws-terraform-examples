output "endpoint" {
  value = aws_db_instance.postgres.address
}

output "domain_name" {
  value = local.domain_name
}

output "username" {
  value = local.db.username
}

output "password" {
  value = local.db.password
}

output "postgres_cdc_replication_task_id" {
  value = local.replication_task_cdc_id
}