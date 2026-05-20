output "postgres_db" {
  value = {
    server_name   = "${local.db.server_name}"
    endpoint      = "${aws_db_instance.postgres.address}"
    database_name = "${local.db.database_name}"
    username      = "${local.db.username}"
    password      = "${local.db.password}"
  }
}

output "replication_config_arn" {
  value = aws_dms_replication_config.serverless_config.arn
}
