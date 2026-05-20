module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = "basic-example-cluster"
}

locals {
  docker_image = "${module.basic_ecs_example_ecr_repository.repository_name}:latest"
}

module "ecs_task" {
  source       = "./modules/ecs_task"
  task_name    = "basic-example-task"
  docker_image = local.docker_image
  cpu          = 256
  memory       = 512
}
