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
  launch_rds = true
}

resource "aws_db_instance" "postgres" {
  count                               = local.launch_rds ? 1 : 0
  identifier                          = "rds-postgres-example"
  instance_class                      = "db.t3.micro"
  engine                              = "postgres"
  engine_version                      = "14.7"
  db_name                             = "experiment"
  allocated_storage                   = 20
  username                            = "postgres"
  manage_master_user_password         = true
  iam_database_authentication_enabled = true
  db_subnet_group_name                = aws_db_subnet_group.postgres.name
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

# route53
locals {
  postgres_domain_name = "postgres.bigmountaintiger.com"
}

resource "aws_route53_record" "cname_route53_record" {
  count   = local.launch_rds ? 1 : 0
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.postgres_domain_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_db_instance.postgres[0].address
  ]

}

