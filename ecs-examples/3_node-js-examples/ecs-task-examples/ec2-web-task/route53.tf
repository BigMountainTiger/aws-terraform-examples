# https://stackoverflow.com/questions/64371831/

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.domain_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_alb.ec2-web-task-alb.dns_name
  ]
  
}

# resource "aws_route53_record" "alias_route53_record" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = local.domain_name
#   type    = "A"

#   alias {
#     evaluate_target_health = false
#     name                   = aws_alb.ec2-web-task-alb.dns_name
#     zone_id                = aws_alb.ec2-web-task-alb.zone_id
#   }

# }
