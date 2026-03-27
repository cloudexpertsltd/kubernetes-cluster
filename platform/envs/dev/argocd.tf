# Kubernetes provider using kubeconfig generated in runner
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm provider uses the Kubernetes provider automatically
provider "helm" {}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
}