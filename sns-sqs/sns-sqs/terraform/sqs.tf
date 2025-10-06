locals {
  visibility_timeout = 60
}

resource "aws_sqs_queue" "queue" {
  name                       = local.sqs_name
  visibility_timeout_seconds = local.visibility_timeout
}

# https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html#principal-roles
# The principal can be "AWS" or "Service"
# "*" principal grant permissions to the current account and other account as well - This needs to be limited
# SourceArn vs. PrincipalArn
resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
          ],
          "Resource" : "${aws_sqs_queue.queue.arn}",
          "Condition" : {
            "ArnLike" : {
              "aws:SourceArn" : "arn:aws:*:*:${data.aws_caller_identity.current.account_id}:*"
            }
          }
        }
      ]
  })
}


resource "aws_sns_topic_subscription" "queue" {
  topic_arn = aws_sns_topic.topic.arn
  endpoint  = aws_sqs_queue.queue.arn
  protocol  = "sqs"
}
