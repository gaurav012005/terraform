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