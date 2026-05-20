output "task_name" {
  value = aws_ecs_task_definition.basic-fargate-task.family
}