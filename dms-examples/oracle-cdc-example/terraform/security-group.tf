resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.vpc-example.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  ingress {
    description = "postgres/5432"
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "oracle/1521"
    protocol    = "tcp"
    from_port   = 1521
    to_port     = 1521
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-sg-${local.vpc_name}"
  }

}
