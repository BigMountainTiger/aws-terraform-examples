resource "aws_dynamodb_table" "time_tracker_control_table" {
  name         = "time_tracker_control_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "table_name"

  attribute {
    name = "table_name"
    type = "S"
  }
}


output "time_tracker_control_table_name" {
  value = aws_dynamodb_table.time_tracker_control_table.name
}
