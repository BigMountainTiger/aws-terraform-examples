resource "aws_sqs_queue" "queue" {
  name                       = "example-sqs-queue"
  visibility_timeout_seconds = local.visibility_timeout
}


# SourceArn and PrincipalArn are different
# Some callers provide SourceArn, some callers provide PrincipalArn
# Only when the value is sent with the request, the IAM rule can take effect
resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*"
          "Action" : [
            "sqs:SendMessage",
            "sqs:ReceiveMessage",
            "sqs:DeleteMessage",
            "sqs:GetQueueAttributes"
          ],
          "Resource" : "${aws_sqs_queue.queue.arn}",
          "Condition" : {
            "ArnLike" : {
              "aws:PrincipalArn" : "arn:aws:*:*:${data.aws_caller_identity.current.account_id}:*"
            }
          }
        }
      ]
  })

}
