DevOps Coding Test
==================

The goal of this coding test was _"Script the creation of a service, and a healthcheck script to verify it is up and responding correctly"_.

## Packer and Ansible

In my proposed solution I've implemented an immutable infrastructure approach, easily achievable using [Packer](https://packer.io). The setup of this image is done using [Ansible](https://www.ansible.com), which allows a more flexible and developer friendly syntax when compared to regular shell scripts, specially if you leverage Ansible Roles.

In this case I've used Ansible to install Docker via a community Ansible Role, and added a playbook task that will prepare the Timeapp to be ready to run.


## Terraform

When the AMI is ready, it can be used by [Terraform](https://www.terraform.io) scripts to create all necessary AWS resources:

 - VPC
 - Public Subnets
 - Private Subnets
 - Auto Scaling Group
 - Security Groups
 - Application Load Balancer
 - DNS Record

 The setup is as follows:
 
  - Timeapp instances are spinned through the Auto Scaling Group, in private subnets across different Availability Zones. These instances are not accessible to the internet, and only allow connections to the port `80` that are originated from the Aplication Load Balancer.
  - The Application Load Balancer is associated with the public subnets created with the VPC, and redirects requests made to port `80` to the Timeapp instances, via Target Group that is associated to the Timeapp Autoscaling Group.
  - The Load Balancer assures the traffic is distributed through all Healthy instances and drains Unhealthy ones, resulting in the Auto Scaling Group terminating the Unhealthy and provisioning new ones.
  - The Auto Scaling Group assures there is always more than one instance running, providing us with high availability.
 
With the use of Terraform Modules, this setup is highly configurable and flexible to all sorts of changes, as well as easily reproducible.

## Timeapp and Healthchecker

Timeapp and healthchecker apps were both developed with Golang in very short files, accompanied by a respective Dockerfile for easiness of deployment.

## Usage Instructions

 - [Timeapp](./timeapp/README.md)
 - [Healthchecker](./healthchecker/README.md)
 - [Packer scripts](./packer/README.md)
 - [Terraform scripts](./terraform/README.md)

## Possible improvements

There is always room for improvement, and possible steps I see to improve this solution even further are:

 - Add serverspec tests to Packer
 - Have the Docker image built by a different pipeline and available in a Docker Registry instead of building it everytime
 - Increase and decrease number of Auto Scaling Group instances based on CPU system load (cpu usage, etc..)
 - Add logging and monitoring tooling to Timeapp instances

## Related work

You can check previous work I did using this kind of approach in my blogpost [Automating infrastructure: playing factorio on AWS
](https://capsule.one/blog/2017/09/28/automating-infrastructure-playing-factorio-on-aws/) where I leverage the same tools to deploy a Factorio server, this time using AWS API Gateway and AWS Lambda.

Code available on [Github](https://github.com/RCM7/aws-factorio).