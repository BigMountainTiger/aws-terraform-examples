module "ecs_cluster" {
  source       = "./modules/ecs_cluster"
  cluster_name = "basic-example-cluster"
}

locals {
  docker_image = "${module.basic_ecs_example_ecr_repository.repository_name}:latest"
}

module "ecs_task_definition" {
  source               = "./modules/ecs_task_definition"
  task_definition_name = "basic-example-task-definition"
  docker_image         = local.docker_image
  cpu                  = 256
  memory               = 512
  target_s3_bucket     = module.s3_bucket.bucket_name
}
