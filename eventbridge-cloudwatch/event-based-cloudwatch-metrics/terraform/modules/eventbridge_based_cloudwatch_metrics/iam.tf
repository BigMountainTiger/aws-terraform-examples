data "aws_iam_policy_document" "eventbridge_permissions" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = [
      "${aws_cloudwatch_log_group.target_loggroup.arn}",
      "${aws_cloudwatch_log_group.target_loggroup.arn}:*"
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "eventbridge_permissions" {
  policy_document = data.aws_iam_policy_document.eventbridge_permissions.json
  policy_name     = var.eventbridge_rule_name
}
