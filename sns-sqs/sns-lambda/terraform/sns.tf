resource "aws_sns_topic" "topic" {
  name = local.sns_name
}

resource "aws_sns_topic_policy" "topic" {
  arn = aws_sns_topic.topic.arn

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": "*",
			"Action": [
				"SNS:Publish",
        "SNS:Receive",
        "SNS:Subscribe"
			],
			"Resource": "${aws_sns_topic.topic.arn}",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
		}
	]
}
EOF

}
