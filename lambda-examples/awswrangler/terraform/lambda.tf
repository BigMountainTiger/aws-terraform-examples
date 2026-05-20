locals {
  lambda_name = "awswrangler_example"
}

resource "aws_lambda_function" "awswrangler_example" {
  function_name = local.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  layers        = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python312:20"]
  filename      = data.archive_file.lambda_code_placeholder.output_path

  memory_size = 128 * 8
  timeout     = 900

  source_code_hash = base64sha256("Never_replace_lambda_code")

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.s3.id
    }
  }
}
