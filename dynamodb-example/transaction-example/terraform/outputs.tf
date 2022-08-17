output "dynamodb-table-name" {
  value = aws_dynamodb_table.example_table.name
}
output "lambda-role-name" {
  value = aws_iam_role.lambda_execution_role.name
}