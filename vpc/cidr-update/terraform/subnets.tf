resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.64.0/18"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.128.0/18"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-3"
  }
}

resource "aws_subnet" "private_subnet_4" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.192.0/18"
  availability_zone = "us-east-1d"

  tags = {
    Name = "private-4"
  }
}
