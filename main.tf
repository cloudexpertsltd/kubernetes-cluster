module "vpc" {
  source = "./modules/vpc"
  cluster_name = var.cluster_name
  region       = "ap-southeast-1"
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
  region       = "ap-southeast-1"
}

module "eks" {
  source               = "./modules/eks"
  cluster_name         = var.cluster_name
  region               = "ap-southeast-1"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
}