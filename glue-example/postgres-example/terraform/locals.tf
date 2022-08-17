locals {
  vpc_name  = "vpc-postgres-example"
  user_name = "song"
  password  = "PWD-1234"

  region = data.aws_region.current.name
}
