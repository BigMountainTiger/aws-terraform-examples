resource "aws_vpc" "vpc-example" {
  cidr_block = "10.0.0.0/16"
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

resource "aws_default_route_table" "default-route" {
  default_route_table_id = aws_vpc.vpc-example.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "public-rt-${local.vpc_name}"
  }
}


