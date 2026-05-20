locals {
  app_name = "swagger-example"
  bucket   = "example.huge.head.li.2023"
}

locals {
  route53_zone_name   = "bigmountaintiger.com"
  acm_domain_name     = "*.bigmountaintiger.com"
  api_domain_name     = "www.bigmountaintiger.com"
  swagger_domain_name = "swagger.bigmountaintiger.com"
}
