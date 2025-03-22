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