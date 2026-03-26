variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_arn" {
  type        = string
  description = "EKS cluster ARN"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}