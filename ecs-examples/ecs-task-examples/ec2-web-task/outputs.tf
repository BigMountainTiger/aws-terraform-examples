output "cluster-name" {
  value = aws_ecs_cluster.basic-empty-cluster.name
}

output "service-name" {
  value = aws_ecs_service.basic-fargate-web-task-service.name
}

output "task-definition" {
  value = aws_ecs_task_definition.basic-ec2-web-task.family
}

output "alb_domain_name" {
  value = aws_alb.ec2-web-task-alb.dns_name
}

output "route53_domain_name" {
  value = aws_route53_record.cname_route53_record.name
}

output "test_url" {
  value = "https://${aws_route53_record.cname_route53_record.name}/hello"
}
