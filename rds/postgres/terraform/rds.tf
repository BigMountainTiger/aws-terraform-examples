resource "aws_db_subnet_group" "postgres" {
  name = "postgres"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "postgres"
  }
}

locals {
  postgres-username = "postgres"
  postgres-pwd      = "password-123"
}

resource "aws_db_instance" "postgres" {
  identifier           = "rds-postgres-example"
  instance_class       = "db.t3.micro"
  engine               = "postgres"
  engine_version       = "15.3"
  db_name              = "experiment"
  allocated_storage    = 20
  username             = local.postgres-username
  password             = local.postgres-pwd
  db_subnet_group_name = aws_db_subnet_group.postgres.name
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
