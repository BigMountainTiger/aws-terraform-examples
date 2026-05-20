# Use nested module "./lambda"

module "lambda_1" {
  source      = "./lambda"
  lambda_name = "external-code-deploy-example"
}


module "lambda_2" {
  source      = "./lambda"
  lambda_name = "another-lambda"
}
