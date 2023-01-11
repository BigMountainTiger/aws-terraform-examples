resource "aws_ecs_task_definition" "basic-fargate-task" {
  family = local.task-name

  container_definitions = jsonencode([
    {
      "name" : "${local.task-name}",
      "image" : "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/example_ecr_repository:step-app"
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "ecs/${local.task-name}",
          "awslogs-region" : "${local.region}",
          "awslogs-create-group" : "true",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}
