module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.1.0"

  name    = var.cluster_name   # updated from cluster_name
  cluster_version = "1.29"     # updated from cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
    }
  }

  enable_irsa = true  # required for service accounts
}