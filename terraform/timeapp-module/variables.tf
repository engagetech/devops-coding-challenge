variable "environment" {}

variable "service_name" {
  default     = "timeapp"
  description = "The name of the app"
}

variable "dns_domain" {
  description = "The domain to which this VPC belongs to. Managed throught the 'environment' variable."
  type        = "map"

  default = {
    stg = "stg.engagetech.capsule.one"
    prd = "prd.engagetech.capsule.one"
  }
}

variable "dns_public_zone_id" {
  description = "The id of the DNS public Zone to place new dns records"
}

variable "vpc_id" {}

variable "vpc_public_subnet_ids" {
  description = "Comma separated list of the private subnet ids"
}

variable "vpc_private_subnet_ids" {
  description = "Comma separated list of the private subnet ids"
}

variable "ec2_instance_type" {
  default = "t2.small"
}

variable "ec2_keypair" {}
variable "ec2_ami_id" {}

variable "ebs_root_volume_type" {
  default = "gp2"
}

variable "ebs_root_volume_size" {
  default = 16
}

variable "ebs_root_volume_iops" {
  default = 0
}

variable "asg_default_cooldown" {
  default     = 300
  description = "Time (in seconds) between a scaling activity and the succeeding scaling activity."
}

variable "asg_health_check_grace_period" {
  default     = 300
  description = "Time (in seconds) after instance comes into service before checking health."
}

variable "asg_health_check_type" {
  default     = "ELB"
  description = "Type of health check to be perform. Must be one of 'EC2' or 'ELB'."
}

variable "max_instances" {
  default = 5
}

variable "min_instances" {
  default = 2
}

variable "desired_instances" {
  default = 3
}

variable "lb_health_check_interval" {
  description = "The inverval for LB Health Checks, in seconds."
  default     = 10
}

variable "lb_health_check_timeout" {
  description = "The connection timeout for LB Health Checks, in seconds."
  default     = 5
}

variable "lb_health_check_healthy_threshold" {
  description = "The number of consecutive LB Health Checks successes required before considering an unhealthy target healthy."
  default     = 5
}

variable "lb_health_check_unhealthy_threshold" {
  description = "The number of consecutive Health Check failures required before considering the target unhealthy."
  default     = 2
}

variable "lb_health_check_matcher" {
  description = "The status codes to use when checking for a successful response from a target."
  default     = 200
}

variable "lb_health_check_path" {
  description = "Path to use for health checks."
  default     = "/now"
}
