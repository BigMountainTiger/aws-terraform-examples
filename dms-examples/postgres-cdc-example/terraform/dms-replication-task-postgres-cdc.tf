locals {
  replication_task_cdc_id = "${local.app_name}-postgres-cdc-task"
}

resource "aws_dms_replication_task" "replication_task_cdc" {
  replication_task_id = local.replication_task_cdc_id
  source_endpoint_arn = aws_dms_endpoint.postgres_source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.postgres_target.endpoint_arn
  migration_type      = "full-load-and-cdc"

  replication_instance_arn = aws_dms_replication_instance.dms_example.replication_instance_arn

  # DROP_AND_CREATE,TRUNCATE_BEFORE_LOAD, DO_NOTHING
  # The configurations here will merge into the default configurations
  # Go to aws console to see all the configuration settings
  replication_task_settings = jsonencode({
    "FullLoadSettings" : {
      "TargetTablePrepMode" : "DROP_AND_CREATE"
    }
  })

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
      },
      {
        "rule-id" : "2",
        "rule-name" : "2",
        "rule-type" : "transformation",
        "rule-action" : "rename",
        "rule-target" : "table",
        "object-locator" : {
          "schema-name" : "public",
          "table-name" : "example"
        },
        "value" : "example_target"
      }
    ]
  })

  tags = {
    Name = local.replication_task_cdc_id
  }

  lifecycle {
    ignore_changes = [
      # replication_task_settings
    ]
  }
}
