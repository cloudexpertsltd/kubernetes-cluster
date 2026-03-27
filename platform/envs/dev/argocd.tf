# Fetch remote state of EKS cluster
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "cloudex-terraform-state-bucket"
    key    = "eks/dev/terraform.tfstate"  # must match your EKS statefile
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# EKS cluster data
locals {
  cluster_name = try(
    data.terraform_remote_state.eks.outputs.cluster_name,
    data.terraform_remote_state.eks.outputs.eks_cluster_name
  )
}

data "aws_eks_cluster" "eks" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = local.cluster_name
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

# Helm provider (will use the default Kubernetes provider)
provider "helm" {}

# Helm release for ArgoCD
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
}