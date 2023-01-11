module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.4"

  cluster_name    = "b_module_cluster"
  cluster_version = "1.24"

  vpc_id                         = local.vpc-id
  subnet_ids                     = [local.public-1, local.public-2]
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

  }
}
