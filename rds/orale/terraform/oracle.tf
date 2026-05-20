locals {
  oracle = {
    username = "oracle"
    pwd      = "password-123"
  }
}

resource "aws_db_instance" "oracle" {
  identifier     = "rds-oracle-example"
  instance_class = "db.t3.small"
  engine         = "oracle-se2"
  engine_version = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
  license_model  = "license-included"

  db_name              = "ORCL"
  allocated_storage    = 20
  username             = local.oracle.username
  password             = local.oracle.pwd
  db_subnet_group_name = aws_db_subnet_group.oracle.name
  vpc_security_group_ids = [
    aws_default_security_group.default-sg.id
  ]

  # Need to enable automated backup to enable ARCHIVELOG
  # SELECT LOG_MODE FROM "V$DATABASE";
  backup_retention_period  = 0
  # backup_retention_period  = 7
  delete_automated_backups = true
  publicly_accessible      = true
  skip_final_snapshot      = true
  apply_immediately        = true
}
