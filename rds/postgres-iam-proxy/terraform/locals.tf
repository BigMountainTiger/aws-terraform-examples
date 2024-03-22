locals {
  app_name = "postgres-iam-proxy"
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