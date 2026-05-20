resource "aws_sns_topic" "example_sns_topic" {
  name = "example-sns-topic"
}

# The following allow SNS:Publish from the account
# and all other accounts
resource "aws_sns_topic_policy" "example_sns_topic" {
  arn = aws_sns_topic.example_sns_topic.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "snsacc",
  "Statement": [
    {
      "Sid": "Account",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.example_sns_topic.arn}",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
    },
    {
      "Sid": "All",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "${aws_sns_topic.example_sns_topic.arn}"
    }
  ]
}
POLICY

}
