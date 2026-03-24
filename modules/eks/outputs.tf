output "cluster_name" {
  value = aws_eks_cluster.this[0].name
}

output "cluster_arn" {
  value = aws_eks_cluster.this[0].arn
}

output "eks_managed_node_group_arns" {
  value = [for ng in aws_eks_node_group.this : ng.arn]
}

output "eks_managed_node_group_names" {
  value = [for ng in aws_eks_node_group.this : ng.node_group_name]
}