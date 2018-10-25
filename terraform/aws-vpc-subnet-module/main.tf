resource "aws_subnet" "default" {
  vpc_id                  = "${var.vpc_id}"
  count                   = "${length(compact(split(",", var.vpc_subnet_cidr_blocks)))}"
  cidr_block              = "${element(split(",", var.vpc_subnet_cidr_blocks), count.index)}"
  availability_zone       = "${element(split(",", var.aws_azs), count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "${lower(var.environment)}-${lower(var.service_name)}-${var.subnet_type}-${element(split(",", var.aws_azs), count.index)}"
    environment = "${lower(var.environment)}"
  }
}

resource "aws_route_table_association" "default" {
  count          = "${length(compact(split(",", var.vpc_subnet_cidr_blocks)))}"
  subnet_id      = "${element(aws_subnet.default.*.id, count.index)}"
  route_table_id = "${element(split(",", var.vpc_route_table_ids), count.index)}"
}
