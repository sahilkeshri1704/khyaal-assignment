module "network" {
  source  = "../modules/network"
  # Baaki variables network module ko pass karne ke liye
  vpc_name          = var.vpc_name
  cidr              = var.vpc_cidr
  azs               = var.azs
  private_subnets   = var.private_subnets_cidr
  public_subnets    = var.public_subnets_cidr
  environment       = var.environment
}

module "eks" {
  source  = "../modules/eks"
  # Baaki variables EKS module ko pass karne ke liye
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnets
  environment       = var.environment
  nodegroup_name    = var.nodegroup_name
  instance_types    = var.instance_types
  nodes_desired_size = var.nodes_desired_size
  nodes_min_size     = var.nodes_min_size
  nodes_max_size     = var.nodes_max_size
}

module "monitoring" {
  source  = "../modules/monitoring"
  # Baaki variables monitoring module ko pass karne ke liye
  prometheus_operator_version = var.prometheus_operator_version
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "5.5.18" # You can also make this a variable if needed
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}