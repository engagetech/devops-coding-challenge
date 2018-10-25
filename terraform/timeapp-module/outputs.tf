output "timeapp_fqdn" {
  value = "${aws_route53_record.public_elb.fqdn}"
}
