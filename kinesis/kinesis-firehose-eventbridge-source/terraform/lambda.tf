data "archive_file" "zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/transformer.zip"
  source_dir  = "${path.module}/../lambdas/transformer"
}

resource "aws_lambda_function" "lambda" {
  function_name = "kinesis_firehose_event_transformer"
  role          = aws_iam_role.lambda.arn
  handler       = "app.lambdaHandler"
  runtime       = "python3.12"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  depends_on = [
    data.archive_file.zip
  ]

}