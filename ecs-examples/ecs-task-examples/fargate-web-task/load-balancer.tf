resource "aws_alb" "fargate-web-task-alb" {
  name               = "fargate-web-task-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    local.public-1,
    local.public-2
  ]

  security_groups = [
    local.security-group
  ]
}

resource "aws_alb_listener" "fargate-web-task-alb-listener" {
  load_balancer_arn = aws_alb.fargate-web-task-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate-web-task-alb-tg.arn
  }
}

resource "aws_lb_target_group" "fargate-web-task-alb-tg" {
  name                 = "fargate-web-task-alb-tg"
  port                 = 8000
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 60
  vpc_id               = local.vpc-id

  health_check {
    enabled = true
    path    = "/healthcheck"
  }

  depends_on = [
    aws_alb.fargate-web-task-alb
  ]
}

