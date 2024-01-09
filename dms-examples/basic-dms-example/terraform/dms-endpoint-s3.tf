locals {
  bucket_name = "huge-head-li-2023-glue-example"
}

resource "aws_iam_role" "s3_access_role" {
  name = "${local.app_name}-s3_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "dms.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_access_role_policy" {
  name = "${aws_iam_role.s3_access_role.name}_policy"
  role = aws_iam_role.s3_access_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectTagging",
          "s3:ListBucket"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# csv target
resource "aws_dms_endpoint" "s3_csv" {
  endpoint_id   = "${local.app_name}-s3-csv-endpoint"
  endpoint_type = "target"
  engine_name   = "s3"

  s3_settings {
    bucket_name             = local.bucket_name
    service_access_role_arn = aws_iam_role.s3_access_role.arn
    timestamp_column_name   = "timestamp"
    add_column_name         = true
  }

  tags = {
    Name = "${local.bucket_name}-csv"
  }
}

# parquet target
resource "aws_dms_endpoint" "s3_parquet" {
  endpoint_id   = "${local.app_name}-s3-parquet-endpoint"
  endpoint_type = "target"
  engine_name   = "s3"

  # max_file_size (in KB) default 1G, important if memory is not enough
  s3_settings {
    bucket_name             = local.bucket_name
    service_access_role_arn = aws_iam_role.s3_access_role.arn
    timestamp_column_name   = "timestamp"
    add_column_name         = true
    max_file_size           = 102400
    data_format             = "parquet"
  }

  tags = {
    Name = "${local.bucket_name}-parquet"
  }
}
