resource "aws_dms_replication_task" "replication_task_parquet" {
  replication_task_id = "${local.app_name}-postgres-to-s3-task-parquet"
  source_endpoint_arn = aws_dms_endpoint.postgres.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.s3_parquet.endpoint_arn
  migration_type      = "full-load"

  replication_instance_arn = aws_dms_replication_instance.dms_example.replication_instance_arn

  table_mappings = jsonencode({
    "rules" : [
      {
        "rule-id" : "1",
        "rule-name" : "1",
        "rule-type" : "selection",
        "object-locator" : {
          "schema-name" : "public",
          "table-name" : "example"
        },
        "rule-action" : "include"
      }
    ]
  })

  tags = {
    Name = "${local.app_name}-postgres-to-s3-task-parquet"
  }

  lifecycle {
    ignore_changes = [
      replication_task_settings
    ]
  }
}
