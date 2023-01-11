locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  cluster-name             = "basic-empty-cluster"
  task-name                = "basic-ec2-task"
  task-execution-role-name = "basic-ec2-task-execution-role"
  task-role-name           = "basic-ec2-task_role"
  ecs-instance-role-name   = "basic-ecs-instance-role"
}

locals {
  vpc-state-key = "vpc-example"
}

locals {
  vpc-id = data.terraform_remote_state.vpc.outputs.vpc-id
}

locals {
  public-1  = data.terraform_remote_state.vpc.outputs.subnet-ids.public-1
  public-2  = data.terraform_remote_state.vpc.outputs.subnet-ids.public-2
  private-1 = data.terraform_remote_state.vpc.outputs.subnet-ids.private-1
  private-2 = data.terraform_remote_state.vpc.outputs.subnet-ids.private-2
}

locals {
  security-group-id   = data.terraform_remote_state.vpc.outputs.default-sg.id
  security-group-name = data.terraform_remote_state.vpc.outputs.default-sg.name
}

