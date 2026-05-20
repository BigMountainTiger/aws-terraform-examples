resource "aws_redshiftserverless_workgroup" "example" {
  workgroup_name = local.workgroup_name
  namespace_name = aws_redshiftserverless_namespace.namespace.namespace_name

  base_capacity = 8

  subnet_ids = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id,
    aws_subnet.public-subnet-3.id
  ]

  # If given private subnets, it is not accessible from the internet
  # subnet_ids = [
  #   aws_subnet.private-subnet-1.id,
  #   aws_subnet.private-subnet-2.id,
  #   aws_subnet.private-subnet-3.id
  # ]

  security_group_ids = [
    aws_default_security_group.default-sg.id
  ]

  # This is necessary to connect to redshift from out of the VPC
  publicly_accessible = true
}
