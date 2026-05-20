output "cluster-name" {
  value = aws_ecs_cluster.basic-empty-cluster.name
}

output "task-definition" {
  value = aws_ecs_task_definition.basic-fargate-task.family
}

output "service-name" {
  value = aws_ecs_service.basic-fargate-web-task-service.name
}

output "alb_url" {
  value = "http://${aws_alb.fargate-web-task-alb.dns_name}/hello"
}