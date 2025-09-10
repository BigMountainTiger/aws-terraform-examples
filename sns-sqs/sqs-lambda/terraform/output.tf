output "sqs_url" {
  value = aws_sqs_queue.queue.url
}

output "publisher_lambda_name" {
  value = aws_lambda_function.lambda_publisher.function_name
}