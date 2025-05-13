resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-1"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-2"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-1"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.vpc-example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-2"
    "kubernetes.io/role/elb" = 1
  }
}


resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}


resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}
