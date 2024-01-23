locals {
  bucket_prefix = "module-example-bucket.huge.head.li"
}

locals {
  deploy_bucket_1 = false
}

# Module support count, when count = 0, it is not provisioned
module "bucket_1" {
  count       = local.deploy_bucket_1 ? 1 : 0
  source      = "./modules/s3"
  bucket_name = "${local.bucket_prefix}-1"
}

module "bucket_2" {
  source      = "./modules/s3"
  bucket_name = "${local.bucket_prefix}-2"
}

# Get the module from a GIT repository
# Notice the double slash for the subdirectory for the module from the GIT repository
module "bucket_remote_git" {
  source      = "git::https://github.com/BigMountainTiger/aws-terraform-examples.git//module-example/modules/s3/?ref=master"
  bucket_name = "${local.bucket_prefix}-git"
}
