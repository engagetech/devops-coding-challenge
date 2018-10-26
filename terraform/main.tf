provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

module "vpc" {
  source                        = "./aws-vpc-module/"
  aws_azs                       = "${var.aws_azs}"
  environment                   = "${var.environment}"
  service_name                  = "engage"
  vpc_cidr_block                = "10.0.0.0/24"
  vpc_public_subnet_cidr_blocks = "10.0.0.0/28,10.0.0.16/28,10.0.0.32/28"
}

module "timeapp_subnets" {
  source                 = "./aws-vpc-subnet-module/"
  service_name           = "timeapp"
  environment            = "${var.environment}"
  aws_azs                = "${var.aws_azs}"
  vpc_id                 = "${module.vpc.vpc_id}"
  vpc_subnet_cidr_blocks = "10.0.0.128/28,10.0.0.144/28,10.0.0.160/28"
  vpc_route_table_ids    = "${module.vpc.vpc_private_route_table_ids}"
  subnet_type            = "private"
}

module "timeapp" {
  source                 = "./timeapp-module/"
  service_name           = "timeapp"
  environment            = "${var.environment}"
  vpc_id                 = "${module.vpc.vpc_id}"
  ec2_keypair            = "${var.ec2_keypair}"
  ec2_ami_id             = "${var.ec2_ami_id}"
  vpc_private_subnet_ids = "${module.timeapp_subnets.subnet_ids}"
  vpc_public_subnet_ids  = "${module.vpc.vpc_public_subnet_ids}"
  dns_public_zone_id     = "${var.dns_public_zone_id}"
}
