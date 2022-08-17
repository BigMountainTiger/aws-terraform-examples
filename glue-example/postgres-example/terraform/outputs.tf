output "db-address" {
  value = aws_db_instance.postgres_example.address
}

output "jdbc-connect-string" {
  value = "jdbc:postgresql://${aws_db_instance.postgres_example.address}:5432/experiment"
}

output "login-info" {
  value = {
    user_name = local.user_name
    password  = local.password
  }
}
