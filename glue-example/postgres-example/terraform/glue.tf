resource "aws_glue_connection" "postgres_example" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:postgresql://${aws_db_instance.postgres_example.address}:5432/experiment"
    USERNAME            = local.user_name
    PASSWORD            = local.password
  }

  physical_connection_requirements {
    availability_zone      = aws_subnet.public-subnet-1.availability_zone
    security_group_id_list = [aws_default_security_group.default-sg.id]
    subnet_id              = aws_subnet.public-subnet-1.id

  }
  
  name = "postgres_example_connection"
}

resource "aws_glue_catalog_database" "postgres_example_database" {
  name = "postgres_example"
}
