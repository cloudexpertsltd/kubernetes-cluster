
region       = "ap-southeast-1"
cluster_name = "dev-eks-cluster"

# VPC Module
vpc_cidr = "10.10.0.0/16"
public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]