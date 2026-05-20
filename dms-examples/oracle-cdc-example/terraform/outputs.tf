output "endpoint" {
  value = aws_db_instance.postgres.address
}

output "postgres" {
  value = {
    server_name = local.db.postgres.server_name
    username    = local.db.postgres.username
    password    = local.db.postgres.password
  }
}

output "oracle" {
  value = {
    server_name = local.db.oracle.server_name
    username    = local.db.oracle.username
    password    = local.db.oracle.password
  }
}

output "oracle_cdc_replication_task_id" {
  value = local.replication_task_cdc_id
}
