# path.module is the folder where the current tf file is located
data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/.tf-zip/${var.lambda_name}.zip"
  source_dir  = "${path.module}/lambda-templates/python-lambda"
}


resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  role          = var.lambda_execution_role_arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename         = data.archive_file.zip.output_path
  source_code_hash = base64sha256("Never_replace_lambda_code")

  tags = {}

  depends_on = [
    data.archive_file.zip
  ]

  lifecycle {
    create_before_destroy = true
  }
}
