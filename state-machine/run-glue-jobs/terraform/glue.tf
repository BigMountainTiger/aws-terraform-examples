locals {
  glue_job_name = "example-glue-job"
}

resource "aws_iam_role" "job" {
  name = local.glue_job_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "job" {
  role       = aws_glue_job.job.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "job" {
  name = aws_glue_job.job.name
  role = aws_glue_job.job.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "s3:GetBucketAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::*.huge.head.li.*/*"
        ]
      }
    ]
  })
}

resource "aws_glue_job" "job" {
  name     = local.glue_job_name
  role_arn = aws_iam_role.job.arn

  max_capacity = "0.0625"
  max_retries  = 0

  command {
    script_location = "s3://${data.aws_s3_bucket.bucket.bucket}/jobs/shell_job.py"
    name            = "pythonshell"
    python_version  = "3.9"
  }
}


data "aws_s3_bucket" "bucket" {
  bucket = "example.huge.head.li.2023"
}

resource "aws_s3_object" "shell_script" {
  bucket      = data.aws_s3_bucket.bucket.id
  key         = "jobs/shell_job.py"
  source      = "${path.module}/python/shell_job.py"
  source_hash = filebase64sha256("${path.module}/python/shell_job.py")
}
