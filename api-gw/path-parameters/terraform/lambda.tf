module "lambda_execution_role" {
  source    = "./modules/lambda_execution_role"
  role_name = "${local.app_name}_lambda_execution_role"
}

module "authorizor" {
  source = "./modules/zip_lambda"

  function_name   = "${local.app_name}-authorizor"
  source_dir      = "${path.module}/../lambdas/api-authorizor"
  zip_output_path = "${path.module}/../.tf-zip/authorizor.zip"

  role_arn = module.lambda_execution_role.arn
  handler  = "app.lambdaHandler"
  runtime  = "python3.10"

  depends_on = [
    module.lambda_execution_role
  ]
}

module "executor" {
  source = "./modules/zip_lambda"

  function_name   = "${local.app_name}-executor"
  source_dir      = "${path.module}/../lambdas/api-executor"
  zip_output_path = "${path.module}/../.tf-zip/executor.zip"

  role_arn = module.lambda_execution_role.arn
  handler  = "app.lambdaHandler"
  runtime  = "python3.10"

  depends_on = [
    module.lambda_execution_role
  ]
}
