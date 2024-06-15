resource "aws_route53_zone" "hosted_zone" {
  name = "aws.groophy.live"
}

resource "aws_route53_record" "lb_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "lb"
  type    = "A"
  alias {
    name                   = aws_lb.app-lb.dns_name
    zone_id                = aws_lb.app-lb.zone_id
    evaluate_target_health = true
  }
}
