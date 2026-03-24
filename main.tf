module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
  region       = var.region
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.public_subnet_ids
  vpc_id       = module.vpc.vpc_id
}

module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
  cluster_arn  = module.eks.cluster_arn
}