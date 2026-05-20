module "s3_bucket" {
  source = "./modules/s3"
  bucket_name = "basic-ecs-example-s3-bucket-huge-head-li"
}