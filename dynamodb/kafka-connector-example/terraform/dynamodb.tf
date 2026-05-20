locals {
  dynamodb_table_name = "kafka-connector-example-table"
}

resource "aws_dynamodb_table" "table" {

  name           = local.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = false

  attribute {
    name = "id"
    type = "S"
  }
}

