variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_azs" {
  default     = "eu-west-1a,eu-west-1b,eu-west-1c"
  description = "List with the Availability Zones for the subnet(s)."
}

variable "environment" {
  default     = "stg"
  description = "The environment designation for which this deployment will be created. Can only be one of: 'stg' or 'prd'."
}

variable "dns_public_zone_id" {
  description = "The id of the public Route53 Zone where the public DNS record for the timeapp will be created."
}

variable "ec2_ami_id" {
  description = "The AMI that will be used to provision new instances."
}

variable "ec2_keypair" {
  description = "The SSH key to be used when provisioning new instances."
}
