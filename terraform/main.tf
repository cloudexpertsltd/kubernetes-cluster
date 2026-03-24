terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.22.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


# ---------------------------
# Kubernetes Provider (using module outputs)
# ---------------------------
provider "kubernetes" {
  host = module.eks.cluster_endpoint

  cluster_ca_certificate = base64decode(
    module.eks.cluster_certificate_authority_data
  )

  token = module.eks.cluster_auth_token
}