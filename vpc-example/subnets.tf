resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.10.0/24"
  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.11.0/24"
  tags = {
    Name = "private-2"
  }
}