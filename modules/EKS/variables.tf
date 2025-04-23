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