locals {
  username = "postgres"
  db_name  = "postgres"
}

resource "aws_db_subnet_group" "postgres_example" {
  name = "postgres_example_subnet_group"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "postgres_rds_instance_subnet_group"
  }
}

resource "aws_db_instance" "postgres_example" {
  identifier                          = "experiment-postgres"
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 20
  engine                              = "postgres"
  engine_version                      = "13.3"
  db_name                             = local.db_name
  username                            = local.username
  password                            = aws_secretsmanager_secret_version.password.secret_string
  db_subnet_group_name                = aws_db_subnet_group.postgres_example.name
  # iam_database_authentication_enabled = true
  publicly_accessible                 = true
  skip_final_snapshot                 = true
}
