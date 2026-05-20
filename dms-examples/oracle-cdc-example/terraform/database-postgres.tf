resource "aws_db_subnet_group" "db" {
  name = "postgres-subnet-group"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "postgres-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier           = "rds-postgres-example"
  instance_class       = "db.t3.micro"
  engine               = "postgres"
  engine_version       = "14.7"
  parameter_group_name = aws_db_parameter_group.cdc_enabled.name

  db_name              = local.db.postgres.database_name
  allocated_storage    = 20
  username             = local.db.postgres.username
  password             = local.db.postgres.password
  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [
    aws_default_security_group.default-sg.id
  ]
  #   Disable automatic backup by setting backup_retention_period = 0
  backup_retention_period  = 0
  delete_automated_backups = true
  publicly_accessible      = true
  skip_final_snapshot      = true

  apply_immediately        = true
}
