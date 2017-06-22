# devops-coding-challenge

This is step-by-step guide about how to deploy and test simple web-app environment on AWS.

Based on [requirements.](https://github.com/engagetech/devops-coding-challenge)

## Prepare local environment

### Install software
I use [Ansible](https://www.ansible.com) on MacOS 10.12.5 Sierra. To install it with [Homebrew](http://docs.brew.sh/Installation.html) run:

    brew install ansible

We also we need to install `boto` module to access AWS resources

    pip install boto

### Configure access to secrets
I use [Ansible Vault](http://docs.ansible.com/ansible/playbooks_vault.html) to encrypt all sensitive variables in configs. To access these secrets you need to copy file `ansible-vault.pass` to the root of project folder.

## Deploy environment

### Single instance
* create EC2 instance
* configure EC2 instance
* deploy web-app to EC2 instance

Navigate to projects folder and run `deploy.yml`

    ./deploy.yml

### Instance and ELB
* create ELB
* create EC2 instance
* configure EC2 instance
* deploy web-app to EC2 instance
* register EC2 instance to ELB

From projects folder run:


    ./deploy_with_elb.yml


## Test environment
1. Get list of EC2 instances tagged by **devops-coding-challenge**
2. get request to EC2 instance public IP address `http://instance-ipv4-address/varsion.txt`
3. if result from step 2 not equal to **app_version** from  `vars/settings.yml` - add instance to configuration group **webservers-to-fix**
4. start or restart NGINX on each EC2 instance from configuration group **webservers-to-fix**

To run test:

    ./test.yml

In case of success - you'll not see any red text in the playbook output

In case playbook didn't get response from EC2 instance by HTTP request or response will be wrong - it start or restart nginx service on EC2 instance
