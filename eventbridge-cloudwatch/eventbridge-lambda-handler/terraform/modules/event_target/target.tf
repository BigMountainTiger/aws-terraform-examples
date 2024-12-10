locals {
  target_name = "${var.rule_name}-${var.target_name}"
}

resource "aws_sqs_queue" "sqs" {
  name = local.target_name

  sqs_managed_sse_enabled    = true
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 1800

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_target" "sqs" {
  event_bus_name = var.eventbridge_bus_name

  rule = var.rule_name
  arn  = aws_sqs_queue.sqs.arn
}

resource "aws_sqs_queue_policy" "sqs" {
  queue_url = aws_sqs_queue.sqs.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : "${aws_sqs_queue.sqs.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${var.rule_arn}"
          }
        }
      }
    ]
  })
}

module "lambda_handler" {
  source = "../lambda_handler"

  rule_name   = var.rule_name
  target_name = var.target_name
  sqs_arn     = aws_sqs_queue.sqs.arn

  config_envs       = var.config_envs
  data_bucket       = var.data_bucket
  credential_secret = var.credential_secret

  sqs_mapping_enabled = true
}
