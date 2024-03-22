resource "aws_iam_role" "simple_example_role" {
  name               = "simple_example_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "simple_example_role_policy" {
  name   = "simple_example_role_policy"
  role   = aws_iam_role.simple_example_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_glue_job" "simple_example" {
  name     = "simple_example"
  role_arn = aws_iam_role.simple_example_role.arn

  command {
    script_location = "s3://example.huge.head.li.2023/run.py"
    python_version  = "3"
  }

  number_of_workers = 2
  worker_type       = "G.1X"

  glue_version = "4.0"

  default_arguments = {
    "--job-language"   = "python"
    "--extra-py-files" = "s3://example.huge.head.li.2023/pkg1.zip"
  }
}
