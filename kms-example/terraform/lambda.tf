data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/${local.function_name}.zip"
  source_dir  = "${path.module}/../lambdas/${local.function_name}"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  memory_size = 128
  timeout     = 60

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = {
      BUCKET      = aws_s3_bucket.s3.bucket
      SECRET_NAME = aws_secretsmanager_secret.secret_example.name
    }
  }

  depends_on = [
    data.archive_file.zip
  ]

}
