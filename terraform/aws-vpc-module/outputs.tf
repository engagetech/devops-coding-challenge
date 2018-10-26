output "vpc_public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_public_route_table_id" {
  value = "${aws_route_table.public.id}"
}

output "vpc_nat_eips" {
  value = "${join(",", aws_eip.nat.*.public_ip)}"
}

output "vpc_igw_id" {
  value = "${aws_internet_gateway.main.id}"
}

output "vpc_nat_gw_ids" {
  value = "${join(",", aws_nat_gateway.main.*.id)}"
}

output "vpc_cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "vpc_default_sg_id" {
  value = "${aws_security_group.default.id}"
}

output "vpc_private_route_table_ids" {
  value = "${join(",", aws_route_table.private_nat_gw.*.id)}"
}

output "dns_zone_id" {
  value = "${aws_route53_zone.default.id}"
}

output "dns_resolvers" {
  value = "${join(",", aws_route53_zone.default.name_servers)}"
}
