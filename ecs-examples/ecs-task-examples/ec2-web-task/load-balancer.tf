resource "aws_alb" "ec2-web-task-alb" {
  name               = "ec2-web-task-alb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    local.public-1,
    local.public-2
  ]

  security_groups = [
    local.security-group-id
  ]
}

data "aws_acm_certificate" "acm_certificate" {
  domain      = local.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_alb_listener" "ec2-web-task-alb-listener" {
  load_balancer_arn = aws_alb.ec2-web-task-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-web-task-alb-tg.arn
  }
}

resource "aws_lb_target_group" "ec2-web-task-alb-tg" {
  name                 = "fargate-web-task-alb-tg"
  port                 = 8000
  protocol             = "HTTP"
  target_type          = "instance"
  deregistration_delay = 60
  vpc_id               = local.vpc-id

  health_check {
    enabled = true
    path    = "/healthcheck"
  }

  depends_on = [
    aws_alb.ec2-web-task-alb
  ]
}

