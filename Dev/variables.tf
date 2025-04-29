variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.28"
}

variable "subnet_ids" {
  type = list(string)
}

variable "nodegroup_name" {
  type    = string
  default = "default-nodes"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "nodes_desired_size" {
  type    = number
  default = 2
}

variable "nodes_min_size" {
  type    = number
  default = 1
}

variable "nodes_max_size" {
  type    = number
  default = 4
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "prometheus_operator_version" {
  type    = string
  default = "56.6.0"
}

variable "vpc_name" {
  type    = string
  default = "eks-app-vpc"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}
