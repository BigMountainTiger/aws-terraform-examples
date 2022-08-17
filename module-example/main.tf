locals {
  bucket_prefix = "module-example-bucket.huge.head.li"
}

module "bucket_1" {
  source = "./modules/s3"
  bucket_name = "${local.bucket_prefix}-1"
}

module "bucket_2" {
  source = "./modules/s3"
  bucket_name = "${local.bucket_prefix}-2"
}
