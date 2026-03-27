# Fetch remote state of EKS cluster
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "cloudex-terraform-state-bucket"
    key    = "eks/dev/terraform.tfstate"  # path to your EKS state
    region = "ap-southeast-1"
  }
}

# AWS provider
provider "aws" {
  region = "ap-southeast-1"
}

# Get cluster info from EKS
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = data.aws_eks_cluster.eks.name
}

# Default Helm provider (for general use)
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# Alternative Helm provider (for ArgoCD, for example)
provider "helm" {
  alias = "argocd"
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  # Use the aliased provider
  provider = helm.argocd
}