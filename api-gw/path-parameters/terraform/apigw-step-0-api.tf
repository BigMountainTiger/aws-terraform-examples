resource "aws_api_gateway_rest_api" "api" {
  name = "path_param_example"

  # The default is edge optimized
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
