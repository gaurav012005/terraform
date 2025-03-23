DevOps Project 1: Multi-Environment Infrastructure with Terraform.


This repository contains Terraform configuration files to deploy an Amazon EKS (Elastic Kubernetes Service) cluster on AWS. The setup follows best practices for infrastructure automation and includes networking, security, and compute resources.

## 📌 **Project Overview**

This Terraform project sets up an EKS cluster with the following components:

- **EKS Cluster**: Managed Kubernetes control plane.
- **VPC and Networking**: VPC, subnets, security groups, and load balancers.
- **Worker Nodes**: EC2 instances in an auto-scaling group.
- **IAM Roles & Policies**: Necessary permissions for EKS and worker nodes.
- **Application Deployment**: Deploy containerized applications on EKS.

## 🏗 **Architecture Diagram**


(![Screenshot 2025-03-23 151019](https://github.com/user-attachments/assets/2a9cf7e2-1035-4ebe-a654-3a1971fb893d)
)

## 🚀 **Prerequisites**

Before you begin, ensure you have the following installed:

- **AWS CLI** (configured with your credentials)
- **Terraform** (>= 1.0.0)
- **IAM Role** (with necessary permissions to create EKS resources)

## 📂 **Project Structure**

```bash
project-2-terraform-eks/
│── eks.tf          # EKS cluster definition
│── vpc.tf          # VPC and networking
│── provider.tf     # AWS provider configuration
│── terraform.tf    # Terraform backend setup
│── local.tf        # Local values and variables
│── README.md       # Documentation
│── image.png       # Architecture diagram
```
Define Terraform Configuration Files :

1.eks.tf
```hcl
module "eks"{
    cluster-addons ={
        vpc-cni ={
            most-recent =true
        }
        kube-proxy = {
            most-recent =true
        }  
        coredns ={
            most-recent =true
        }
        
        
          }

    #source the moduel
    source =" terraform-aws-module/eks/aws"
   
#for cluster info
    cluster_name =  local.name
    cluster_endpoint_public_access = true

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    #control plane network
    control_plane_subnets_ids = module.vpc.infra_subnets 
    

    # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    
    instance_types = ["t2.medium"]
    attach_cluster_primary_security_group = true

  }

  eks_managed_node_groups = {
    cluster-ng = {
      
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
      capactity_type = "SPOT"
    }
  }


    tags = {
        Environment =local.env
        Terraform = "true"

    }
}
```
2. local.tf
```hcl
locals {
  region  = "us-east-1"
  name = "eks-cluster"
  vpc_cidr = "10.0.0.0/16"
  azs = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24","10.0.102.0/24"]
  intra_subnets = ["10.0.5.0/24","10.0.6.0/24"]
  env ="dev"
}
```
3.provider.tf
```hcl
provider "aws"{
    region = "us-east-1a"
}
```
4.terraform.tf 
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
5.vpc.tf 
```hcl
module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "5.17.0"

name ="${ local.name}-vpc"
cidr = local.vpc_cidr
azs = local.azs
private_subnets = local.private_subnets
public_subnets = local.public_subnets
intra_subnets = local.infra_subnets
enable_nat_gateway = true
enable_vpn_gateway = true

tags = {
Terraform = "true"
Environment =local.env
}
}
```


## 🔧 **Setup & Deployment**

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks
```

### 2️⃣ Initialize Terraform

```sh
terraform init
```

### 3️⃣ Plan the Deployment

```sh
terraform plan
```

### 4️⃣ Apply the Terraform Configuration

```sh
terraform apply -auto-approve
```

Terraform will create the necessary AWS resources.

### 5️⃣ Configure `kubectl`

```sh
aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>
kubectl get nodes
```

### 6️⃣ Deploy Applications

```sh
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

To check running applications:

```sh
kubectl get pods -A
kubectl get services -A
```

## 🗑 **Cleanup**

To delete all resources:

```sh
terraform destroy -auto-approve
```

If not clear : https://github.com/LondheShubham153/terraform-for-devops/tree/main/eks
