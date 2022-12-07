#######
# Route53 / DNS

resource "aws_route53_record" "beacon_rr" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.app_domain
  type    = "A"

  alias {
    evaluate_target_health = true
    name                   = aws_lb.beacon_compose_alb.dns_name
    zone_id                = aws_lb.beacon_compose_alb.zone_id
  }
}
