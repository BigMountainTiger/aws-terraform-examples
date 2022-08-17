resource "aws_db_subnet_group" "postgres_example" {
  name = "postgres_example"
  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  tags = {
    Name = "postgres_example"
  }
}

resource "aws_db_instance" "postgres_example" {
  identifier           = "experiment-postgres"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.3"
  username             = local.user_name
  password             = local.password
  db_subnet_group_name = aws_db_subnet_group.postgres_example.name
  publicly_accessible  = true
  skip_final_snapshot  = true
}
