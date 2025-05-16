module "the_lambda" {
  source = "./modules/the_lambda"

  lambda_name    = "cidr-update-example-lambda"
  lambda_runtime = "python3.11"
}
