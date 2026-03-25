data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name   # <--- use cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name   # <--- use cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      # GitHub Actions runner
      {
        rolearn  = "arn:aws:iam::865809098262:role/GitHubRunnerRole"
        username = "github"
        groups   = ["system:masters"]
      },
      # Node group role
      {
        rolearn  = module.eks.managed_node_group_iam_role_arns["default"]
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers","system:nodes"]
      }
    ])
  }

  depends_on = [module.eks]
}