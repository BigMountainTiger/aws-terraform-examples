data "aws_api_gateway_export" "swagger" {
  rest_api_id = aws_api_gateway_stage.gateway_stage.rest_api_id
  stage_name  = aws_api_gateway_stage.gateway_stage.stage_name
  export_type = "oas30"

  depends_on = [
    aws_api_gateway_stage.gateway_stage
  ]
}

resource "local_file" "swagger" {
  filename = "${path.module}/../.swagger/${local.app_name}-swagger.json"
  content  = data.aws_api_gateway_export.swagger.body
}


