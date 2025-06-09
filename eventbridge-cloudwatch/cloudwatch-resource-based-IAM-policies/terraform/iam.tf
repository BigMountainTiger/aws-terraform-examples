data "aws_iam_policy_document" "eventbridge_rule_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = [
      "${aws_cloudwatch_log_group.log_group.arn}",
      "${aws_cloudwatch_log_group.log_group.arn}:*"
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

# The policy_name should be unique among all "aws_cloudwatch_log_resource_policy"
# create by terraform, AWS CLI, or any other means
resource "aws_cloudwatch_log_resource_policy" "eventbridge_rule_policy" {
  policy_document = data.aws_iam_policy_document.eventbridge_rule_policy.json
  policy_name     = "${local.event_name}-log-policy"
}
