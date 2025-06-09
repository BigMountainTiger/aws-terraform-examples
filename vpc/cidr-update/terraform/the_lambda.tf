module "the_lambda" {
  source = "./modules/the_lambda"

  lambda_name    = "cidr-update-example-lambda"
  lambda_runtime = "python3.11"

  security_group_ids = [aws_default_security_group.default-sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id,
    aws_subnet.private_subnet_4.id
  ]
}
