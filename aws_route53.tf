data "aws_route53_zone" "webapp_route53" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "webapp_a_record" {
  zone_id = data.aws_route53_zone.webapp_route53.zone_id
  name    = data.aws_route53_zone.webapp_route53.name
  type    = "A"
  ttl     = "60"
  records = [aws_instance.webapp_instance[0].public_ip]
}