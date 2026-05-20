locals {
  replication_task_cdc_id = "${local.app_name}-oracle-cdc-task"
}

resource "aws_dms_replication_task" "replication_task_cdc" {
  replication_task_id = local.replication_task_cdc_id
  source_endpoint_arn = aws_dms_endpoint.oracle_source.endpoint_arn
  target_endpoint_arn = aws_dms_endpoint.postgres_target.endpoint_arn
  migration_type      = "full-load-and-cdc"

  replication_instance_arn = aws_dms_replication_instance.dms_example.replication_instance_arn

  replication_task_settings = jsonencode({
    "TargetMetadata" : {
      "TargetSchema" : "public"
    },
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
          "schema-name" : "ORACLE",
          "table-name" : "EXAMPLE"
        },
        "rule-action" : "include"
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
