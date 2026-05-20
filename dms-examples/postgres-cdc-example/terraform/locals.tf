locals {
  app_name = "dms-postgres-cdc-example"
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
