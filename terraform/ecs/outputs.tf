output "cluster_arn" {
  description = "The arn of the Cluster"
  value       = module.ecs_cluster.arn
}

output "region" {
  value = var.region
}

output "cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group created"
  value       = module.ecs_cluster.cloudwatch_log_group_arn
}

output "name" {
  description = "Name that identifies the cluster"
  value       = module.ecs_cluster.name
}

output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group created"
  value       = module.ecs_cluster.cloudwatch_log_group_name
}

output "cluster_capacity_providers" {
  description = "Map of cluster capacity providers attributes"
  value       = module.ecs_cluster.cluster_capacity_providers
}

output "task_exec_iam_role_arn" {
  description = "The arn of the task execution IAM role"
  value       = module.ecs_cluster.task_exec_iam_role_arn
}