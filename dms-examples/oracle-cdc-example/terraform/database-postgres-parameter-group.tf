resource "aws_db_parameter_group" "cdc_enabled" {
  name   = "cdc-enabled"
  family = "postgres14"

  # This is to enable CDC on the postgres database
  parameter {
    name  = "rds.logical_replication"
    value = "1"

    apply_method = "pending-reboot"
  }
}
