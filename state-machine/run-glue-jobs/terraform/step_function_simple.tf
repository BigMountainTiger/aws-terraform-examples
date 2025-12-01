
locals {
  simple_step_function_name      = "simple-state-machine-example"
}

resource "aws_sfn_state_machine" "sfn_simple_state_machine" {
  name     = local.simple_step_function_name
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode(
    {
      "StartAt" : "Start",
      "States" : {
        "Start" : {
          "Type" : "Pass",
          "Result" : {
            "input_0": "input_0_value"
          },
          "Next" : "Step_1"
        },
        "Step_1" : {
          "Type" : "Pass",
          "Parameters" : {
            "param_1.$" : "$.input_0"
          },
          "Next" : "job_2"
        },
        "job_2" : {
          "Type" : "Pass",
          "End" : true
        }
      }
  })
}
