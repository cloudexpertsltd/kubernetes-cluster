# ---------------------------
# EKS Module
# ---------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.3.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.35"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
    }
  }

  enable_irsa = true
}

# ---------------------------
# Access Entry for akash
# ---------------------------
resource "aws_eks_access_entry" "akash" {
  cluster_name  = var.cluster_name
  principal_arn = "arn:aws:iam::865809098262:user/akash"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "akash_admin" {
  cluster_name  = var.cluster_name
  principal_arn = "arn:aws:iam::865809098262:user/akash"

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [module.eks]
}