locals {
  app_name = "dms-postgres-serverless-example"
}

locals {
  route53_zone_name = "bigmountaintiger.com"
}

locals {
  db = {
    server_name   = "postgres.bigmountaintiger.com"
    database_name = "experiment"
    username      = "postgres"
    password      = "password-123"
    port          = 5432
  }
}
