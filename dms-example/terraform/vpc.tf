locals {
  vpc_name = "dms-example-vpc"
}

resource "aws_vpc" "vpc-example" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-example.id
  tags = {
    Name = local.vpc_name
  }
}



