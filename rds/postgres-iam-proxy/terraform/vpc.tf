# VPC
resource "aws_vpc" "vpc-example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.app_name
  }
}

# IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-example.id
  tags = {
    Name = local.app_name
  }
}

# Default route table
resource "aws_default_route_table" "default-route" {
  default_route_table_id = aws_vpc.vpc-example.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "public-rt-${local.app_name}"
  }
}

# Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-example.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1-${local.app_name}"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-example.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2-${local.app_name}"
  }
}

# Security group
resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.vpc-example.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    description = "postgres/5432"
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-sg-${local.app_name}"
  }
}



