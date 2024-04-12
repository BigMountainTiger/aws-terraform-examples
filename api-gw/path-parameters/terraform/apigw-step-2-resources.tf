resource "aws_api_gateway_resource" "sect_1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "sect-1"
}

resource "aws_api_gateway_resource" "param_1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.sect_1.id
  path_part   = "{param_1}"
}

resource "aws_api_gateway_resource" "sect_2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.param_1.id
  path_part   = "sect-2"
}

resource "aws_api_gateway_resource" "param_2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.sect_2.id
  path_part   = "{param_2}"
}

