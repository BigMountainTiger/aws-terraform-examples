# https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
# The IAM role ARN is set on the whole API Gateway leverl per AWS region

resource "aws_iam_role" "apigw_cloudwatch_role" {
  name = "apigateway_cloudwatch_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigw_cloudwatch_role" {
  name = local.role_name
  role = aws_iam_role.apigw_cloudwatch_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_api_gateway_method_settings" "execution_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    # Enable execution logs
    metrics_enabled = false
    logging_level   = "INFO"
  }
}


resource "aws_cloudwatch_log_group" "access_log" {
  name              = "${local.app_name}-access_log"
  retention_in_days = 1
}
