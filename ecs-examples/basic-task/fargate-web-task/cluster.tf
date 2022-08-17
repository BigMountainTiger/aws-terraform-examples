resource "aws_ecs_cluster" "basic-empty-cluster" {
   name = local.cluster-name
}