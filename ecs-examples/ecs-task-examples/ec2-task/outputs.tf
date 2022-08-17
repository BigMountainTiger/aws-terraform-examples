output "cluster-name" {
  value = aws_ecs_cluster.basic-empty-cluster.name
}

output "task-definition" {
  value = aws_ecs_task_definition.basic-fargate-task.family
}