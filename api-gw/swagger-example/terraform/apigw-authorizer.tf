resource "aws_iam_role" "auth_invocation_role" {
  name = "auth_invocation_role"
  path = "/"
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

resource "aws_iam_role_policy" "auth_invocation_role_policy" {
  name = "auth_invocation_role_policy"
  role = aws_iam_role.auth_invocation_role.id
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
  name                             = "authorizer"
  type                             = "REQUEST"
  identity_source                  = "method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 15

  rest_api_id            = aws_api_gateway_rest_api.api_gw.id
  authorizer_uri         = aws_lambda_function.authorizer_lambda.invoke_arn
  authorizer_credentials = aws_iam_role.auth_invocation_role.arn
}
