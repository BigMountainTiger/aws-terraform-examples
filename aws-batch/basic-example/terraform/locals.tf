data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

locals {
  app_name = "aws-batch-basic-example"
}

locals {
  route53_zone_name = "bigmountaintiger.com"
  domain_name       = "postgres.bigmountaintiger.com"
}

locals {
  db_name           = "experiment"
  postgres_username = "postgres"
  postgres_password = "passwd-123"
}
