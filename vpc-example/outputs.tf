output "vpc-id" {
  value = aws_vpc.vpc-example.id
}

output "default-sg-id" {
  value = aws_default_security_group.default-sg.id
}

output "default-sg-name" {
  value = aws_default_security_group.default-sg.tags["Name"]
}

output "subnet-ids" {
  value = {
    public-1 = aws_subnet.public-subnet-1.id
    public-2 = aws_subnet.public-subnet-2.id
    private-1 = aws_subnet.private-subnet-1.id
    private-2 = aws_subnet.private-subnet-2.id
  }
}