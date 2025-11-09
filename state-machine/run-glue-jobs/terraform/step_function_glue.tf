
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = local.step_function_name
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode(
    {
      "StartAt" : "Choose_job_arguments",
      "States" : {
        "Choose_job_arguments" : {
          "Type" : "Choice",
          "Choices" : [
            {
              "Variable" : "$.glue_job_arguments",
              "IsPresent" : true,
              "Next" : "with_arguments"
            },
            {
              "Variable" : "$.glue_job_arguments",
              "IsPresent" : false,
              "Next" : "without_arguments"
            }
          ]
        }
        "with_arguments" : {
          "Type" : "Pass",
          "Parameters" : {
            "arguments.$" : "$.glue_job_arguments"
          },
          "Next" : "job_1"
        },
        "without_arguments" : {
          "Type" : "Pass",
          "Parameters" : {
            "arguments" : {}
          },
          "Next" : "job_1"
        },
        "job_1" : {
          "Type" : "Task",
          "Resource" : "arn:aws:states:::glue:startJobRun.sync",
          "Parameters" : {
            "JobName" : "${aws_glue_job.job.name}",
            "Arguments.$" : "$.arguments"
          },
          "ResultPath" : null,
          "Next" : "wait_twenty_seconds"
        },
        "wait_twenty_seconds" : {
          "Type" : "Wait",
          "Seconds" : 20,
          "Next" : "job_2"
        },
        "job_2" : {
          "Type" : "Task",
          "Resource" : "arn:aws:states:::glue:startJobRun.sync",
          "Parameters" : {
            "JobName" : "${aws_glue_job.job.name}",
            "Arguments.$" : "$.arguments"
          },
          "ResultPath" : null,
          "End" : true
        }
      }
  })
}
