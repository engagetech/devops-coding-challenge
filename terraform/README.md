# Terraform Timeapp

The terraform component includes the following modules:

 - [aws-vpc-module](./aws-vpc-module/README.md) - Create VPC where we'll deploy all resources
 - [aws-vpc-subnet-module](./aws-vpc-subnet-module/README.md) - Create private subnets where Timeapp instances will be deployed
 - [timeapp-module](./timeapp-module/README.md) - Create Timeapp deployment

## Requirements

 - Terraform - (used 0.11.7) - [Installation Docs](https://www.terraform.io/downloads.html)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_access_key | - | string | - | yes |
| aws_azs | List with the Availability Zones for the subnet(s). | string | `eu-west-1a,eu-west-1b,eu-west-1c` | no |
| aws_region | - | string | `eu-west-1` | no |
| aws\_secret_key | - | string | - | yes |
| dns\_public\_zone_id | The id of the public Route53 Zone where the public DNS record for the timeapp will be created. | string | - | yes |
| ec2\_ami_id | The AMI that will be used to provision new instances. | string | - | yes |
| ec2_keypair | The SSH key to be used when provisioning new instances. | string | - | yes |
| environment | The environment designation for which this deployment will be created. Can only be one of: 'stg' or 'prd'. | string | `stg` | no |

## Usage
```
# export env vars for terraform to use
$ export TF_VAR_aws_access_key=$AWS_ACCESS_KEY_ID
$ export TF_VAR_aws_secret_key=$AWS_SECRET_ACCESS_KEY

# copy and edit input variables
$ cp timeapp.tfvars.sample timeapp.tfvars
$ vim timeapp.tfvars

$ terraform init
$ terraform plan -var-file=timeapp.tfvars -out terraform.plan
$ terraform apply terraform.plan
```

## Outputs

| Name | Description |
|------|-------------|
| timeapp_url | - |