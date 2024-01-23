resource "aws_db_subnet_group" "postgres" {
  name = "postgres-${local.app_name}"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "postgres-${local.app_name}"
  }
}

resource "aws_db_instance" "postgres" {
  identifier        = "rds-postgres-example"
  instance_class    = "db.t3.micro"
  engine            = "postgres"
  engine_version    = "15.3"
  allocated_storage = 20

  db_name  = local.db_name
  username = local.postgres_username
  password = local.postgres_password

  iam_database_authentication_enabled = true

  db_subnet_group_name = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [
    aws_default_security_group.default-sg.id
  ]

  #  Disable automatic backup
  #  by setting backup_retention_period = 0
  backup_retention_period  = 0
  delete_automated_backups = true
  publicly_accessible      = true
  skip_final_snapshot      = true
  apply_immediately        = true
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.domain_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_db_instance.postgres.address
  ]

}
