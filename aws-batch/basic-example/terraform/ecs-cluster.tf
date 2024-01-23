resource "aws_ecs_cluster" "basic-empty-cluster" {
   name = "${local.app_name}-cluster"
}