# Timeapp Terraform Module

A terraform module to create and manage timeapp deployments in AWS.

This module will create an Autoscaling Group with multiple instances of Timeapp across different Availability Zones.

Inbound requests go to an Application Load Balancer and are forwarded to the Timeapp instances.

The Timeapp endpoint `/now` is also used as healthcheck for the Load Balancer to drain Unhealthy instances, and for the Auto Scaling Group to terminate them and create new ones.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asg\_default_cooldown | Time (in seconds) between a scaling activity and the succeeding scaling activity. | string | `300` | no |
| asg\_health\_check\_grace_period | Time (in seconds) after instance comes into service before checking health. | string | `300` | no |
| asg\_health\_check_type | Type of health check to be perform. Must be one of 'EC2' or 'ELB'. | string | `ELB` | no |
| desired_instances | - | string | `3` | no |
| dns\_domain | The domain to which this VPC belongs to. Managed throught the 'environment' variable. | map | `<map>` | no |
| dns\_public\_zone_id | The id of the DNS public Zone to place new dns records | string | - | yes |
| ebs\_root\_volume_iops | - | string | `0` | no |
| ebs\_root\_volume_size | - | string | `16` | no |
| ebs\_root\_volume_type | - | string | `gp2` | no |
| ec2\_ami_id | - | string | - | yes |
| ec2\_instance_type | - | string | `t2.small` | no |
| ec2_keypair | - | string | - | yes |
| environment | - | string | - | yes |
| lb\_health\_check\_healthy_threshold | The number of consecutive LB Health Checks successes required before considering an unhealthy target healthy. | string | `5` | no |
| lb\_health\_check_interval | The inverval for LB Health Checks, in seconds. | string | `10` | no |
| lb\_health\_check_matcher | The status codes to use when checking for a successful response from a target. | string | `200` | no |
| lb\_health\_check_path | Path to use for health checks. | string | `/now` | no |
| lb\_health\_check_timeout | The connection timeout for LB Health Checks, in seconds. | string | `5` | no |
| lb\_health\_check\_unhealthy_threshold | The number of consecutive Health Check failures required before considering the target unhealthy. | string | `2` | no |
| max_instances | - | string | `5` | no |
| min_instances | - | string | `2` | no |
| service_name | The name of the app | string | `timeapp` | no |
| vpc_id | - | string | - | yes |
| vpc\_private\_subnet_ids | Comma separated list of the private subnet ids | string | - | yes |
| vpc\_public\_subnet_ids | Comma separated list of the private subnet ids | string | - | yes |

## Usage

```
module "timeapp" {
  source                 = "./timeapp-module/"
  service_name           = "timeapp"
  environment            = "stg"
  vpc_id                 = "vpc-04793656e61730a"
  ec2_keypair            = "your-ssh-key"
  ec2_ami_id             = "ami-09cf0fb8ff8269c8f"
  vpc_private_subnet_ids = "subnet-0b91069166f1d21a1,subnet-0c90c69cc6fcd28aa,subnet-0797067768f9928c9"
  vpc_public_subnet_ids  = "subnet-0b91c69c66c1dc1a1,subnet-0ca0ca9ca6fad2aaa,subnet-2794065768a992cb9"
  dns_public_zone_id     = "ZXW99LFDMOAMRV"
}
```

## Outputs

| Name | Description |
|------|-------------|
| timeapp_fqdn | - |
