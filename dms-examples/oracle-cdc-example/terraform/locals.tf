locals {
  app_name = "dms-oracle-cdc-example"
}

locals {
  db = {
    oracle = {
      server_name   = "oracle.bigmountaintiger.com"
      database_name = "ORCL"
      username      = "oracle"
      password      = "password-123"
      port          = 1521
    },
    postgres = {
      server_name   = "postgres.bigmountaintiger.com"
      database_name = "experiment"
      username      = "postgres"
      password      = "password-123"
      port          = 5432
    }

  }
}
