resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "5.5.18" # Specify the desired ArgoCD version

  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}