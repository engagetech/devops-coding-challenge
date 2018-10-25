# Timeapp Packer

Packer scripts to create the Timeapp base image.

## Requirements

 - Ansible - (used 2.6.2) - [Installation Docs](http://docs.ansible.com/ansible/latest/intro_installation.html)
 - Packer - (used 1.3.1) - [Installation Docs](https://www.packer.io/downloads.html)

## Configuration

Copy the `variables.json.sample` file and customize accordingly.

```
$ cp variables.json.sample variables.json
$ vim variables.json
$ cat variables.json
{
  "source_ami": "ami-0483f1cc1c483803f",
  "vpc_id": "",
  "subnet_id": "",
  "region": "eu-west-1",
  "docker_version": "18.06.1",
  "timeapp_version": "0.0.1"
}
```

## Usage

Load your AWS credentials. E.g.

```
export AWS_ACCESS_KEY_ID=heresomeaccesskey
export AWS_SECRET_ACCESS_KEY=heresomesecretkey
```

Install Ansible requirements:

```
$ ansible-galaxy install -r ./requirements.yml -p ./roles
```

Build Timeapp image:

```
$ packer build -var-file=variables.json ./packer.json
```

If everything goes as expected, at the end of the previous command output you'll get the new ami:

```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
eu-west-1: ami-09cf0fb8ff8269c8f
```
This will be used on the next step with Terraform.