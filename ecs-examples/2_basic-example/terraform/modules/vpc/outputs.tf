output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_aws_security_group_id" {
  value = data.aws_security_group.default.id
}

output "aws_subnet_ids" {
  value = data.aws_subnets.all.ids
}
