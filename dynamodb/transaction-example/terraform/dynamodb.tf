resource "aws_dynamodb_table" "example_table" {

  name             = "dynamodb-transaction-example-table"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = false

  attribute {
    name = "id"
    type = "S"
  }
}

