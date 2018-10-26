variable "service_name" {
  description = "The name/reference for this subnet(s)."
  default     = "general"
}

variable "environment" {
  description = "The environment designation for which this VPC will be created. Can only be one of: 'stg' or 'prd'."
}

variable "aws_azs" {
  description = "List with the Availability Zones for the subnet(s)."
}

variable "vpc_id" {
  description = "The id of the VPC that the subnet(s) will belong to."
}

variable "vpc_subnet_cidr_blocks" {
  description = "List with the The CIDR block(s) for the subnet(s)."
}

variable "vpc_route_table_ids" {
  description = "Route table ids."
}

variable "subnet_type" {
  description = "For naming purposes only. Indicate 'private' or 'public', according to the route tables specified."
}
