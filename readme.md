## Introduction
- The Tasks and corresponding subtasks have been completed with the combination of Terraform and Anisble. 
    
## Scripts
- Terraform Scripts
    - alb.tf - Sets up application load balancer, listner rules and target groups
    - anisble-playbook.tf - Executes ansible playbooks from bastion instance to install docker and jenkins on the jenkins and app host as applicable
    - ec2-instnace.tf - Sets up below EC2 instances
        - ec2-instance with awscli installation 
        - bastion-host
        - jenkins-host
        - app-host
    - ecr.tf - creates and private ecr repo with repository name app
    - keypair.tf -  generates keypair and pem file for access
    - output.tf - List of Output variables
    - provider.tf -  AWS provider setup
    - s3.tf - Creates S3 bucket  
    - security-group.tf -  Creates SG required as per requirements for host instances
    - setup-proxy-jump-bastion.tf and setup-proxy-jump-jenkins.tf -  Setup for proxyjump
    - vars.tf -  Variables used in terraform scripts
    - version.tf
    - vpc.tf - Includes VPC, IG, NAT, Subnets and Route tables
- Ansible-playbooks
    - install-docker.yml
    - install-jenkins.yml

- Dockerfile - for building docker application
- Jenkinsfile - for pipeline setup

## How to run the scripts
```
* Ensure you have the vars.tf file updated with required variables
* Ensure you have AWS_ACCESS_KEY and AWS_SECRET_KEY updated in the default values or be ready to provide them when you run the script

Run below commands
    terraform init
    terraform plan
    terraform apply

Destroy infrastructure
    terraform destroy && rm -rf terraform-key.pem

Note the output variables at the end of the script execution
```

## What is not covered in Automation
- Jenkins setup for pipeline is not covered in automation. Follow below steps to complete the setup.
- Creating user with ecr access
- Install awscli on app-host and run aws configure to save credentials to authenticate ECR

## How to setup Jenkins

- Login to app-host-instance and configure aws by running command aws configure
    - Use access credentials with ecr access
- Run docker login –u AWS –p $(aws ecr get-login-password) --region us-east-1 https://aws_account_id.dkr.ecr.us-east-1.amazonaws.com
- Access Jenkins using the URL: http://<<lb_dns_name>>/jenkins
- Get the initial setup password from Jenkins instance at location /var/lib/jenkins/secrets/initialAdminPassword
    - ssh -i terraform-key.pem ubuntu@<bastion_public_ip> ssh jenkinsserver 
    - sudo cat /var/lib/jenkins/secrets/initialAdminPassword 
- Follow instructions to setup Jenkins instance and create first user
- Navigate to Manage Jenkins and install plugins ssh Agent, docker-pipeline and Amazon ECR
- Follow the link for instructions to create your first pipeline https://geekflare.com/create-jenkins-pipeline/
    - Copy the pipeline script from Jenkinsfile in the repo to set up the pipeline
    - Ensure to update the below lines before execution in the script
        - registry = 'provide the output variable of ecr repo here'
        - registryCredential = 'name of aws ecr repo credentials'
            - Follow the section "Configure AWS Credentials in Jenkins" to help you set up the ecr credentials https://betterprogramming.pub/how-to-push-a-docker-image-to-amazon-ecr-with-jenkins-ed4b042e141a
