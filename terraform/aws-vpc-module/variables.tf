variable "service_name" {
  description = "The name/reference for this VPC."
  default     = "default"
}

variable "environment" {
  description = "The environment designation for which this VPC will be created. Can only be one of: 'stg' or 'prd'."
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/24"
}

variable "vpc_public_subnet_cidr_blocks" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/28"
}

variable "dns_domain" {
  description = "The domain to which this VPC belongs to. Managed throught the 'environment' variable."
  type        = "map"

  default = {
    stg = "stg.engagetech.capsule.one"
    prd = "prd.engagetech.capsule.one"
  }
}

variable "dns_ttl" {
  default = "600"
}

variable "aws_azs" {
  description = "List of Availability Zones to use for this VPC subnets."
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to have custom DNS hostnames within the VPC."
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to have DNS support whitin the VPC."
  default     = true
}
