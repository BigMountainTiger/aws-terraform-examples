resource "aws_sns_topic" "topic" {
  name = local.sns_name
}

# "SNS:Receive",
# "SNS:Subscribe"

resource "aws_sns_topic_policy" "topic" {
  arn = aws_sns_topic.topic.arn

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : [
            "SNS:Publish",
            "SNS:Receive",
            "SNS:Subscribe"
          ],
          "Resource" : "${aws_sns_topic.topic.arn}",
          "Condition" : {
            "ArnLike" : {
              "aws:PrincipalArn" : "arn:aws:*:*:${data.aws_caller_identity.current.account_id}:*"
            }
          }
        }
      ]
  })
}
