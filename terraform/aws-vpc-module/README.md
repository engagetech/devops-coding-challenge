# VPC Terraform Module

A terraform module to create and manage a VPC in AWS.


## Module Input Variables

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_azs | List of Availability Zones to use for this VPC subnets. | string | - | yes |
| dns_domain | The domain to which this VPC belongs to. Managed throught the 'environment' variable. | map | `<map>` | no |
| dns_ttl | - | string | `600` | no |
| enable\_dns_hostnames | Should be true if you want to have custom DNS hostnames within the VPC. | string | `true` | no |
| enable\_dns_support | Should be true if you want to have DNS support whitin the VPC. | string | `true` | no |
| environment | The environment designation for which this VPC will be created. Can only be one of: 'stg' or 'prd'. | string | - | yes |
| service_name | The name/reference for this VPC. | string | `default` | no |
| vpc\_cidr_block | - | string | `10.0.0.0/24` | no |
| vpc\_public\_subnet\_cidr_blocks | The CIDR block for the VPC. | string | `10.0.0.0/28` | no |

## Usage

```hcl

module "vpc" {
  source                        = "./aws-vpc-module/"
  
  aws_azs                       = "eu-west-1a,eu-west-1b,eu-west-1c"
  environment                   = "stg"
  service_name                  = "engage"
  vpc_cidr_block                = "10.0.0.0/24"
  vpc_public_subnet_cidr_blocks = "10.0.0.0/28,10.0.0.16/28,10.0.0.32/28"
}

```


## Outputs

| Name | Description |
|------|-------------|
| dns_resolvers | - |
| dns\_zone_id | - |
| vpc_cidr | - |
| vpc\_default\_sg_id | - |
| vpc_id | - |
| vpc\_igw_id | - |
| vpc\_nat_eips | - |
| vpc\_nat\_gw_ids | - |
| vpc\_private\_route\_table_ids | - |
| vpc\_public\_route\_table_id | - |
| vpc\_public\_subnet_ids | - |
