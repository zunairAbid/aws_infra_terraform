# aws_db_subnet_group
output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.subnet_group.name
}

# aws_rds_cluster
output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster.rds_cluster.arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.rds_cluster.id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = aws_rds_cluster.rds_cluster.cluster_members
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = aws_rds_cluster.rds_cluster.endpoint
}

output "cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster"
  value       = aws_rds_cluster.rds_cluster.reader_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = aws_rds_cluster.rds_cluster.engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = aws_rds_cluster.rds_cluster.database_name
}

output "cluster_port" {
  description = "The database port"
  value       = aws_rds_cluster.rds_cluster.port
}

output "cluster_master_password" {
  description = "The database master password"
  value       = aws_rds_cluster.rds_cluster.master_password
  sensitive   = true
}

output "cluster_master_username" {
  description = "The database master username"
  value       = aws_rds_cluster.rds_cluster.master_username
  sensitive   = true
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = aws_rds_cluster.rds_cluster.hosted_zone_id
}

# aws rds cluster instances
output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = aws_rds_cluster_instance.cluster_instances
}

# aws security group id of the cluster
output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = aws_rds_cluster.rds_cluster.vpc_security_group_ids
}