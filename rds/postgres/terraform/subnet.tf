resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc-example.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = local.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1-${local.vpc_name}"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc-example.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = local.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2-${local.vpc_name}"
  }
}
