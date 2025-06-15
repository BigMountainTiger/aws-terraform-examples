resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_default_route_table" "default-route" {
  default_route_table_id = aws_vpc.example_vpc.default_route_table_id

  tags = {
    Name = "default-private-rt-${local.vpc_name}"
  }
}
