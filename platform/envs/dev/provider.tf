
data "aws_eks_cluster" "this" {
  name = "dev-eks-cluster"
}

data "aws_eks_cluster_auth" "this" {
  name = "dev-eks-cluster"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}