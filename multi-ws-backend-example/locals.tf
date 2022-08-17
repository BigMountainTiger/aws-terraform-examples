locals {
  region = data.template_file.region.rendered
  bucket_name = "s3-example-${var.backend-name}.huge.head.li-${local.region}"
}
