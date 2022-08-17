output "vpc-id" {
  value = aws_vpc.vpc-example.id
}

output "default-sg" {
  value = {
    id = aws_default_security_group.default-sg.id
    name = aws_default_security_group.default-sg.tags["Name"]
  }
}

output "ecs_endpoint_sg" {
  value = {
    id = aws_security_group.ecs_endpoint_sg.id
    name = aws_security_group.ecs_endpoint_sg.tags["Name"]
  }
}

output "subnet-ids" {
  value = {
    public-1 = aws_subnet.public-subnet-1.id
    public-2 = aws_subnet.public-subnet-2.id
    private-1 = aws_subnet.private-subnet-1.id
    private-2 = aws_subnet.private-subnet-2.id
  }
}