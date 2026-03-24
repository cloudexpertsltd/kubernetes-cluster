module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.3.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id = module.vpc.vpc_id
  # This is the correct argument for public subnets
  public_subnets = module.vpc.public_subnet_ids

  # Let the module create roles automatically
  create_eks_role  = true
  create_node_groups_role = true

  # Define a simple managed node group
  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_size         = 1
      max_size         = 3
      instance_types   = ["t3.medium"]
    }
  }

  enable_irsa = true
}