locals {
  lambda_name = "state-machine-simple-example-lambda"
}

module "lambda_target" {
  source = "./modules/lambda"

  lambda_name               = local.lambda_name
  lambda_execution_role_arn = aws_iam_role.lambda_execution_role.arn
}
