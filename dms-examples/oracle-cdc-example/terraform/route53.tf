locals {
  route53_zone_name = "bigmountaintiger.com"
}

data "aws_route53_zone" "primary" {
  name         = local.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "cname_postgres_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.db.postgres.server_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_db_instance.postgres.address
  ]

}

resource "aws_route53_record" "cname_orale_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = local.db.oracle.server_name
  type    = "CNAME"
  ttl     = "60"

  records = [
    aws_db_instance.oracle.address
  ]

}
