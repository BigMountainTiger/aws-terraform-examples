resource "aws_iam_role" "auth_invocation" {
  name = "auth_invocation_role"
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

resource "aws_iam_role_policy" "auth_invocation" {
  name = "auth_invocation_role_policy"
  role = aws_iam_role.auth_invocation.id
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Action" : "lambda:InvokeFunction",
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name                   = "gateway-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = module.authorizor.invoke_arn
  authorizer_credentials = aws_iam_role.auth_invocation.arn

  type = "TOKEN"

  authorizer_result_ttl_in_seconds = 0
}
