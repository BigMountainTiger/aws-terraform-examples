# resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "ecr-api-endpoint" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "ecs" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ecs"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "ecs-agent" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ecs-agent"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "ecs-telemetry" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ecs-telemetry"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "secretsmanager" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.secretsmanager"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "cloudwatch" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.logs"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "ec2" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.ec2"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "sts" {
#   vpc_id              = aws_vpc.vpc-example.id
#   private_dns_enabled = true
#   service_name        = "com.amazonaws.${local.region}.sts"
#   vpc_endpoint_type   = "Interface"
#   security_group_ids  = [aws_security_group.ecs_endpoint_sg.id]
#   subnet_ids          = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
# }

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.vpc-example.id
#   service_name      = "com.amazonaws.${local.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = [
#     aws_route_table.private.id,
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


# Need to remove the VPC endpoints as each cost $0.01/hour


