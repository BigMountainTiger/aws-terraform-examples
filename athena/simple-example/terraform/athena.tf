locals {
  dabase_name           = "simple_athena_database"
  table_name            = "example_data"
  input_format          = "org.apache.hadoop.mapred.TextInputFormat"
  output_format         = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
  serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
  athena_workgroup_name = "test-athena-work-group"
}

resource "aws_athena_workgroup" "example" {
  name = local.athena_workgroup_name
  force_destroy = true
}

resource "aws_glue_catalog_database" "glue_database" {
  name = local.dabase_name
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = local.table_name
  database_name = local.dabase_name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification" = "csv"
  }

  storage_descriptor {
    location      = "s3://huge-head-li-2023-glue-example/example-data/"
    input_format  = local.input_format
    output_format = local.output_format

    ser_de_info {
      serialization_library = local.serialization_library
      parameters = {
        separatorChar            = ","
        "skip.header.line.count" = "1"
      }
    }

    columns {
      name = "last_name"
      type = "string"
    }

    columns {
      name = "given_name"
      type = "string"
    }

    columns {
      name = "full_name"
      type = "string"
    }
  }

  depends_on = [
    aws_glue_catalog_database.glue_database
  ]

}
