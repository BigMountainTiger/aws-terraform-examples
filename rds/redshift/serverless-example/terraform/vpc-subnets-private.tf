resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-1"
  }
}

resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-2"
  }
}


resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.12.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "private-3"
  }
}


resource "aws_route_table_association" "private-subnet-3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}
