aws_region = "ap-south-1" # Mumbai region
environment = "prod" # Example environment

vpc_name = "my-mumbai-vpc"
vpc_cidr = "10.20.0.0/16"
azs = ["ap-south-1a", "ap-south-1b"] # Availability Zones in Mumbai
private_subnets_cidr = ["10.20.1.0/24", "10.20.2.0/24"]
public_subnets_cidr = ["10.20.101.0/24", "10.20.102.0/24"]

cluster_name = "mumbai-eks-cluster"
cluster_version = "1.29"
nodegroup_name = "mumbai-workers"
instance_types = ["m5.large"]
nodes_desired_size = 3
nodes_min_size = 2
nodes_max_size = 5

prometheus_operator_version = "57.2.0"