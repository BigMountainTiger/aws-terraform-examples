locals {
  sqs_name    = "sqs-lambda-example"
  lambda_publisher_name = "sqs-message-publisher"
  lambda_consumer_name = "sqs-lambda-example-processor"
  visibility_timeout = 60
}
