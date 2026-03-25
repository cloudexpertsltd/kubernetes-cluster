output "cluster_name" {
  value = module.this_eks.cluster_name
}

output "cluster_arn" {
  value = module.this_eks.cluster_arn
}

eks_managed_node_groups_iam_role_arns = {
  <node_group_name> = <iam_role_arn>
}