# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.rds-postgres-vpc.id
#   service_name      = "com.amazonaws.${local.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = [
#     aws_default_route_table.default-route.id
#   ]
# }

# resource "aws_vpc_endpoint_policy" "s3" {
#   vpc_endpoint_id = aws_vpc_endpoint.s3.id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "s3-endpoint",
#         "Effect" : "Allow",
#         "Principal" : {
#           "AWS" : "*"
#         },
#         "Action" : [
#           "s3:*"
#         ],
#         "Resource" : "*"
#       }
#     ]
#   })
# }
