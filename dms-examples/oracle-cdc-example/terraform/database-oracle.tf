resource "aws_db_instance" "oracle" {
  identifier        = "rds-oracle-example"
  instance_class    = "db.t3.small"
  engine            = "oracle-se2"
  engine_version    = "19.0.0.0.ru-2023-10.rur-2023-10.r1"
  license_model     = "license-included"
  allocated_storage = 20

  db_name              = local.db.oracle.database_name
  username             = local.db.oracle.username
  password             = local.db.oracle.password
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [
    aws_default_security_group.default-sg.id
  ]

  # Need to enable automated backp to allow archivelog
  # to enable CDC
  backup_retention_period  = 7
  delete_automated_backups = true
  publicly_accessible      = true
  skip_final_snapshot      = true

  apply_immediately = true
}
