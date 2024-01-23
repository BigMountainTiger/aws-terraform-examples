output "endpoint" {
  value = {
    postgres_server   = local.domain_name
    db_name           = local.db_name
    postgres_username = local.postgres_username
    postgres_password = local.postgres_password
  }
}

output "vpc" {
  value = {
    vpc_id            = aws_vpc.vpc-example.id
    security_group_id = aws_vpc.vpc-example.default_security_group_id

    subnets = [
      aws_subnet.public-subnet-1.id,
      aws_subnet.public-subnet-2.id
    ]
  }
}

output "ecs_task" {
  value = {
    task_name = aws_ecs_task_definition.basic-fargate-task.family
    cluster   = aws_ecs_cluster.basic-empty-cluster.name
  }
}

output "batch_job_queue" {
  value = aws_batch_job_queue.batch_example.name
}

output "aws_batch_job_definition" {
  value = aws_batch_job_definition.batch_example.name
}
