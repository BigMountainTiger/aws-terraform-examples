locals {
  step_function_name = "state-machine-simple-example-sfn"
}

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = local.step_function_name
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${module.lambda_target.lambda_arn}",
      "End": true
    }
  }
}
EOF
}
