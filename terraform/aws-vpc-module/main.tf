#
# VPC for the infrastructure.
#
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}"
    environment = "${lower(var.environment)}"
  }
}

#
# Gateway for outside world access (internet access).
#
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}

#
# DHCP configurations.
#
resource "aws_vpc_dhcp_options" "main" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name         = "${lower(lookup(var.dns_domain, lower(var.environment)))}"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}

#
# Base network routing.
#

# using nat gateway
resource "aws_route_table" "private_nat_gw" {
  count = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"

  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-private-${element(split(",", var.aws_azs), count.index)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_route" "private_nat_gw" {
  count                  = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"
  route_table_id         = "${element(aws_route_table.private_nat_gw.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-public"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

#
# Base subnets and respective routing associations.
#

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"

  count = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"

  cidr_block              = "${element(split(",", var.vpc_public_subnet_cidr_blocks), count.index)}"
  availability_zone       = "${element(split(",", var.aws_azs), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-public-${element(split(",", var.aws_azs), count.index)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", var.vpc_public_subnet_cidr_blocks))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#
# Default Security Group (allows traffic between instances).
#
resource "aws_security_group" "default" {
  name   = "${lower(var.environment)}-${lower(var.service_name)}-sg"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-sg"
    environment = "${lower(var.environment)}"
  }
}

#
# DNS record.
#

resource "aws_route53_zone" "default" {
  name    = "${lookup(var.dns_domain, var.environment)}"
  vpc_id  = "${aws_vpc.main.id}"
  comment = "${lower(var.environment)} ${var.service_name} private DNS"

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}"
    environment = "${lower(var.environment)}"
  }
}
