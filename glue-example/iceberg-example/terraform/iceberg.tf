resource "aws_glue_catalog_database" "iceberg_example" {
  name = "iceberg_example"
}

resource "aws_glue_catalog_table" "student" {
  database_name = aws_glue_catalog_database.iceberg_example.name
  name          = "student"

  table_type = "EXTERNAL_TABLE"

  open_table_format_input {
    iceberg_input {
      metadata_operation = "CREATE"
    }
  }

  storage_descriptor {
    location = "s3://${aws_s3_bucket.s3.id}/iceberg_example/student/"

    columns {
      name = "id"
      type = "int"
    }
    columns {
      name = "name"
      type = "string"
    }
    columns {
      name = "score"
      type = "int"
    }
  }
}
