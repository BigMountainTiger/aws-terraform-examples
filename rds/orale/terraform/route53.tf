locals {
  route53_zone_name = "bigmountaintiger.com"
  domain_name       = "oracle.bigmountaintiger.com"
}

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
    aws_db_instance.oracle.address
  ]

}
