module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.3.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.35"

  cluster_iam_role_arn = aws_iam_role.eks_cluster_role.arn
  node_iam_role_arn    = aws_iam_role.eks_node_role.arn

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids

  managed_node_groups = {
    default = {
      desired_capacity = 2
      min_size         = 1
      max_size         = 3
      instance_types   = ["t3.medium"]
    }
  }

  enable_irsa = true
}