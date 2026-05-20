data "archive_file" "layer_psycopg2_zip" {
  type        = "zip"
  output_path = "${path.module}/../.tf-zip/psycopg2.zip"
  source_dir  = "${path.module}/../layers/psycopg2"
}

resource "aws_lambda_layer_version" "psycopg2" {
  layer_name = "psycopg2"

  filename         = data.archive_file.layer_psycopg2_zip.output_path
  source_code_hash = data.archive_file.layer_psycopg2_zip.output_base64sha256
  compatible_runtimes = [
    "python3.10"
  ]
}
