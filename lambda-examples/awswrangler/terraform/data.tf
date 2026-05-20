data "archive_file" "lambda_code_placeholder" {
  type        = "zip"
  output_path = "${path.module}/.zip/lambda_function_python_placeholder.zip"

  source {
    filename = "app.py"
    content  = <<-EOT
    import json

    def lambda_handler(event, context):
        msg = 'This is the placeholder file. If you see this, something has not been deployed'

        return {
            'statusCode': 200,
            'body': json.dumps(msg)
        }
    EOT
  }
}
