data "aws_route53_zone" "webapp_route53" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "webapp_a_record" {
  zone_id = data.aws_route53_zone.webapp_route53.zone_id
  name    = data.aws_route53_zone.webapp_route53.name
  type    = "A"

  alias {
    name                   = aws_lb.webapp_lb.dns_name
    zone_id                = aws_lb.webapp_lb.zone_id
    evaluate_target_health = true
  }
}