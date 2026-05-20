resource "aws_ecs_service" "basic-fargate-web-task-service" {
  name                = local.service-name
  launch_type         = "EC2"
  task_definition     = aws_ecs_task_definition.basic-ec2-web-task.arn
  cluster             = aws_ecs_cluster.basic-empty-cluster.id
  scheduling_strategy = "DAEMON"

  load_balancer {
    target_group_arn = aws_lb_target_group.ec2-web-task-alb-tg.arn
    container_name = "${local.task-name}"
    container_port   = "8000"
  }
}
