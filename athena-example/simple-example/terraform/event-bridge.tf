resource "aws_cloudwatch_event_rule" "athena_event" {
  name        = "athena-example-event-bridge-event"
  description = "Capture athena-example eventbridge event"

  event_pattern = jsonencode({
    "source" : [
      "aws.athena"
    ],
    "detail-type" : [
      "Athena Query State Change"
    ],
    "detail" : {
      "workgroupName" : [
        "${local.athena_workgroup_name}"
      ]
    }
  })
}
