resource "aws_ecs_service" "basic-fargate-web-task-service" {
  name            = local.service-name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.basic-fargate-task.arn
  cluster         = aws_ecs_cluster.basic-empty-cluster.id
  desired_count   = 1

  network_configuration {
    assign_public_ip = false
    security_groups = [
      local.security-group
    ]
    subnets = [
      local.private-1,
      local.private-2
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate-web-task-alb-tg.arn
    container_name = "${local.task-name}"
    container_port   = "8000"
  }
}
