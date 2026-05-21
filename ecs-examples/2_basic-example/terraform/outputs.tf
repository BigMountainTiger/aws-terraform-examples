output "target_s3_bucket" {
  value = module.s3_bucket.bucket_name
}

output "ecr_repository_name" {
  value = module.basic_ecs_example_ecr_repository.repository_name
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_task_definition_name" {
  value = module.ecs_task_definition.task_definition_name
}

output "default_security_group_id" {
  value = module.default_vpc.default_aws_security_group_id
}

output "default_vpc_id" {
  value = module.default_vpc.default_vpc_id
}

output "default_subnet_ids" {
  value = module.default_vpc.aws_subnet_ids
}