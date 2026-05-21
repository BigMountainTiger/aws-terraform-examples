resource "aws_iam_role" "task_role" {
  name = "${var.task_definition_name}-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "task_policy" {
  name        = "task_policy"
  description = "task_policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
  ] })

}

resource "aws_iam_role_policy_attachment" "ecs_task_s3" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}


