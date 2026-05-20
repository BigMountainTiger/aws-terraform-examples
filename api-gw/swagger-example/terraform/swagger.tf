# https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on

# The depends_on meta-argument instructs Terraform to complete all actions on the dependency object 
# (including Read actions) before performing actions on the object declaring the dependency.

data "aws_api_gateway_export" "swagger" {
  rest_api_id = aws_api_gateway_stage.gateway_stage.rest_api_id
  stage_name  = aws_api_gateway_stage.gateway_stage.stage_name
  export_type = "oas30"

  depends_on = [
    aws_api_gateway_stage.gateway_stage
  ]
}

resource "local_file" "swagger" {
  filename = "${path.module}/static/${local.app_name}-swagger.json"
  content  = data.aws_api_gateway_export.swagger.body

  depends_on = [
    data.aws_api_gateway_export.swagger
  ]
}

resource "aws_s3_object" "swagger" {
  bucket = local.bucket
  key    = "${local.app_name}-swagger.json"
  source = local_file.swagger.filename
  etag   = md5(local_file.swagger.content)

  force_destroy = true

  depends_on = [
    local_file.swagger
  ]
}

locals {
  index_html = "${path.module}/static/index.html"
}
resource "aws_s3_object" "index_html" {
  bucket = local.bucket
  key    = "index.html"
  source = local.index_html
  etag   = filemd5(local.index_html)

  content_type        = "text/html"
  content_disposition = "inline"

  force_destroy = true
}
