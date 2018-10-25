# Subnet Terraform Module

A terraform module to create and manage a collection of Subnets in a VPC in AWS.


## Module Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_azs | List with the Availability Zones for the subnet(s). | string | - | yes |
| environment | The environment designation for which this VPC will be created. Can only be one of: 'stg' or 'prd'. | string | - | yes |
| service_name | The name/reference for this subnet(s). | string | `general` | no |
| subnet_type | For naming purposes only. Indicate 'private' or 'public', according to the route tables specified. | string | - | yes |
| vpc_id | The id of the VPC that the subnet(s) will belong to. | string | - | yes |
| vpc\_route\_table_ids | Route table ids. | string | - | yes |
| vpc\_subnet\_cidr_blocks | List with the The CIDR block(s) for the subnet(s). | string | - | yes |

## Usage

```hcl
module "timeapp_subnets" {
  source                 = "./aws-vpc-subnet-module/"
  service_name           = "timeapp"
  environment            = "stg"
  aws_azs                = "eu-west-1a,eu-west-1b,eu-west-1c"
  vpc_id                 = "vpc-04793656e61730a"
  vpc_subnet_cidr_blocks = "10.0.0.128/28,10.0.0.144/28,10.0.0.160/28"
  vpc_route_table_ids    = "rtb-022ea3c7c3c4366cb,rtb-042ec3c7c9c436ac2,rtb-723eb3d7c3e436ec7"
  subnet_type            = "private"
}
```


## Outputs

| Name | Description |
|------|-------------|
| subnet_ids | - |
