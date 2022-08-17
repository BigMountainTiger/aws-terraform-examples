locals {
  private-subnets = [local.private-1, local.private-2]
}

locals {
  public-subnets = [local.public-1, local.public-2]
}

locals {
  all-subnets = [local.public-1, local.public-2, local.private-1, local.private-2]
}
