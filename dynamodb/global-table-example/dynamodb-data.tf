resource "aws_dynamodb_table_item" "data_1" {
  table_name = aws_dynamodb_table.us-east-2.name
  hash_key   = aws_dynamodb_table.us-east-2.hash_key
  item = jsonencode({
    "id" : { "S" : "1" },
    "name" : { "S" : "Item No.1" }
  })
}

resource "aws_dynamodb_table_item" "data_2" {
  table_name = aws_dynamodb_table.us-east-2.name
  hash_key   = aws_dynamodb_table.us-east-2.hash_key
  item = jsonencode({
    "id" : { "S" : "2" },
    "name" : { "S" : "Item No.2" }
  })
}
