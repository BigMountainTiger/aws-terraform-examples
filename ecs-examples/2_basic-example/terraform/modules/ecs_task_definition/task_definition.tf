data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region     = data.aws_region.current.region
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecs_task_definition" "basic-fargate-task" {
  family = var.task_definition_name

  container_definitions = jsonencode([
    {
      "name" : "${var.task_definition_name}",
      "image" : "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${var.docker_image}",
      environment = [
        { name = "target_s3_bucket", value = "${var.target_s3_bucket}" }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "ecs/${var.task_definition_name}",
          "awslogs-region" : "${local.region}",
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}
