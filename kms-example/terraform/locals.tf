data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

locals {
  function_name = "kms_example_lambda"
}

locals {
  bucket_name = "kms-example-bucket-huge-head-li"
}

locals {
  secret_name = "kms-example-secret"
  credentials = {
    user     = "Example_user"
    password = "Not a true password"
  }
}
