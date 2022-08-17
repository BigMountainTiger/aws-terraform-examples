data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "A_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.domain_name
  type    = "A"
  ttl     = "60"

  records = [
    aws_instance.kafka_instance.public_ip
  ]

  depends_on = [
    aws_security_group.kafka_instance
  ]
}
