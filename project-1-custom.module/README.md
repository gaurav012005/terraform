DevOps Project 1: Multi-Environment Infrastructure with Terraform.

Introduction
This comprehensive DevOps project demonstrates how to set up a robust, multi-environment infrastructure using Terraform  for configuration management. The project covers creating infrastructure for development, staging, and production environments, with a focus on automation, scalability, and best practices.

Project Overview
The project involves:

1.Installing Terraform 

2.Setting up AWS infrastructure

3.Creating dynamic inventories


Automating infrastructure management
---

# Terraform Setup for Multi-Environment Infrastructure

Here is how you can set up the infrastructure using Terraform alone.

## 1. Installing Terraform

If you have not already installed Terraform, follow these instructions:

### Update the Package List:
```bash
sudo apt-get update
```

### Install Dependencies:
```bash
sudo apt-get install -y gnupg software-properties-common
```

### Add HashiCorp's GPG Key:
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### Add the HashiCorp Repository:
```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### Install Terraform:
```bash
sudo apt-get update && sudo apt-get install terraform
```

### Verify the Installation:
```bash
terraform --version
```

## 2. Setting Up the Project Directory

To keep everything organized, you will need to set up the project structure for Terraform.

Now you have the following directory structure:

```
project-1-custom.module/
├── infra-app/
│   ├── dynamodb.tf
│   ├── ec2.tf
│   ├── s3.tf
│   ├── variable.tf
│   ├── README.md
│   ├── main.tf
│   ├── provider.tf
│   └── terraform.tf
```

## 3. Define Terraform Configuration Files

### 3.1. Providers and Backend Configuration (provider.tf) (s3.tf)
```hcl
provider "aws" {
  region = "us-west-2"  # Change to your desired region
}

resource "aws_s3_bucket" "remote-s3" {
  bucket = "${var.env}-${var.bucket_name}"
  filename             = "${path.module}/files/outputfile"
  
  tags ={
    Name = "my-bucket"
    Environment = var.env

  }
  
}
```

### 3.2. EC2 Instance Configuration  and dynamodb (ec2.tf) (dynamodb.tf)
```hcl
resource "aws_key_pair" "my_key_new"{
    key_name = "${var.env}-infra-app-key"
    public_key = file {"terra-key-ec2.pub"}

    tags= {
        Environment = var.env
    }
 }

 resource "aws_default_vpc" "default"{

 }

 resource "aws_security_group" "my_security_group"{
    name = "${var.env}-infra_app-sg"
   vpc_id = aws_default_vpc.default.vpc_id

 }

ingress{
    from_port =22
    to_port =22
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="ssh open"
}


ingress{
    from_port =80
    to_port =80
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="htto open"
}


ingress{
    from_port =8000
    to_port =8000
    protoco; = "tcp"
    cidr_blocks =["0.0.0.0/0"]
    description ="flask app"
}


 gress{
    from_port =0
    to_port =0
    protoco; = "-1"
    cidr_blocks =["0.0.0.0/0"]
    description ="all access 
}

#ec2
resource "aws_instance" "my_instance"{
    count = var.instance_count
    depends_on [aws_security_group.my_security_group,aws_key_pair.my_key_new]
    key_name = aws_key_pair.my_key_new.key_name
    security_group =[aws_security_group.my_security_group.name]
    instance_type = var.instance_type
    ami = var.ami_id
    root_block_device{
        volume_size =var.env =="prd" ? 20 :10
    }

    tags +{
        Name = "${var.env}-infra_app-ec2"
        Environment =var.env
    }

     }


### 3.3. DynamoDB Table Configuration (dynamodb.tf)
```hcl
resource "aws_dynamodb_table" "basic-dynamodb-table" {
                    name           = "${var.en}-infra-app-table"
  billing_mode   = "PAY_AS_PER_REQUEST"
  hash_key       = "var.hash.key"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
                Name        = "${var.env}-infra-app-table"
    Environment = var.env
  }
}
```

### 3.3. main and variables (main.tf) (variables.tf)
```hcl
module "dev-infra" {
  source = "./infra-app"
  env ="dev"
  bucket_name = "infra-app-bucket"
  instance_count = 1
  instance_type = "t2.micro"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

module "prd-infra"{
  source = "./infra-app"
  env ="prd"
  bucket_name = "infra-app-bucket"
  instance_count = 2
  instance_type = "t2.micro"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

module "stg-infra" {
  source = "./infra-app"
  env ="stg"
  bucket_name = "infra-app-bucket"
  instance_count = 1
  instance_type = "t2.small"
  ami_id = "ami-084568db4383264d4"
  hash_key = "studentId"
}

#variable.tf
variable "env" {
 
  description = "this is my environment "
  type = string
}


variable "bucket_name"{
  description = "this is my bucket "
  type = string
}

variable "instance_count"{
  description = "this is no of instnace "
  type = number
}

variable "instance_type"{
  description = "this is my instnce type"
  type = string
}

variable "ami_id"{
  description = "this is my bucket "
  type = string
}

variable "hash_key{
  description = "this is thus is hachkey"
  type = string
}
```
### 3.4. terraform (terraform.tf)
```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

### Initialize Terraform (this installs necessary plugins and providers):
```bash
terraform init
```

### Review the Execution Plan:
```bash
terraform plan
```

### Apply the Changes to provision resources:
```bash
terraform apply
```

### Confirm the Action when prompted (or use -auto-approve to skip the prompt):
```bash
terraform apply -auto-approve
```

Terraform will create the resources (EC2 instances, S3 buckets, and DynamoDB tables).

## 5. Clean Up the Infrastructure

When you're done, you can destroy the infrastructure to avoid incurring costs.

### Navigate to the project directory and run:
```bash
terraform destroy
```
If not clear  : https://github.com/LondheShubham153/terraform-ansible-multi-env 



