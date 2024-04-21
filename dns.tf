resource "aws_route53_zone" "your_domain_zone" {
  name = "koffimichel.online"
}
resource "aws_route53_zone" "learning_subdomain_zone" {
  name = "learning.koffimichel.online"
}
resource "aws_acm_certificate" "wildcard_certificate" {
  domain_name       = "learning.koffimichel.online"
  validation_method = "DNS"

  tags = {
    Name = "Wildcard Certificate"
  }
}
