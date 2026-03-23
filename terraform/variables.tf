variable "region" {
  type        = string
  description = "AWS region to deploy EKS"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}