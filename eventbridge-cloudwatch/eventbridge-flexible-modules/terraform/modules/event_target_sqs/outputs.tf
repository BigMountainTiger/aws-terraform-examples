output "sqs_name" {
  value = aws_sqs_queue.sqs.name
}

output "sqs_arn" {
  value = aws_sqs_queue.sqs.arn
}
