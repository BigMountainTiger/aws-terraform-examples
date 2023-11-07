locals {
  redshift_s3_access_role_name = "redshift_s3_access_role"
}

resource "aws_iam_role" "redshift_s3_access" {
  name = local.redshift_s3_access_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "redshift.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_s3_access" {
  name = "${local.redshift_s3_access_role_name}_policy"
  role = aws_iam_role.redshift_s3_access.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : "${aws_s3_bucket.s3.arn}"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })
}
