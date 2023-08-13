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

output "replication_task_csv" {
  value = aws_dms_replication_task.replication_task_csv.replication_task_arn
}

output "replication_task_parquet" {
  value = aws_dms_replication_task.replication_task_parquet.replication_task_arn
}