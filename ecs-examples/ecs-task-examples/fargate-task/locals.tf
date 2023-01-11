locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  cluster-name = "basic-empty-cluster"
  task-name    = "basic-fargate-task"
  task-execution-role-name = "basic-fargate-task-execution-role"
  task-role-name = "basic-fargate-task_role"
}
