output "sns_arn" {
  value = aws_sns_topic.topic.arn
}

output "publisher_lambda_name" {
  value = aws_lambda_function.lambda_publisher.function_name
}