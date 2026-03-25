
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      # GitHub Actions runner role
      {
        rolearn  = "arn:aws:iam::865809098262:role/default-eks-node-group-20260324201906423700000001"
        username = "admin"
        groups   = ["system:masters"]
      },
      # Add GitHubRunnerRole
      {
        rolearn  = "arn:aws:iam::<ACCOUNT_ID>:role/GitHubRunnerRole"
        username = "github"
        groups   = ["system:masters"]
      },

      # EKS Node Group role (hardcoded)
      {
        rolearn  = "arn:aws:iam::865809098262:role/default-eks-node-group-20260324201906423700000001"  # <-- replace with your node group IAM role ARN from AWS console
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers","system:nodes"]
      }
    ])
  }

  depends_on = [module.eks]
}
