resource "aws_iam_role" "db_connect_role" {
  name = "${local.app_name}_iam_db_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.account_id}"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "db_connect_role" {
  name = "${local.app_name}_iam_db_role_policy"
  role = aws_iam_role.db_connect_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBInstances"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "rds-db:connect"
        ],
        "Resource" : [
          "arn:aws:rds-db:us-east-1:${data.aws_caller_identity.current.account_id}:dbuser:*/iam_user",
          "arn:aws:rds-db:us-east-1:${data.aws_caller_identity.current.account_id}:dbuser:*/iam_user_1",
          "arn:aws:rds-db:us-east-1:${data.aws_caller_identity.current.account_id}:dbuser:*/iam_user_2"
        ]
      }
    ]
  })
}
