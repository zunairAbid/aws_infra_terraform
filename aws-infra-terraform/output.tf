output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "private-subnets" {
  description = "Private Subnet ID"
  value       = module.networking.private_subnet
}

output "public-subnets" {
  description = "Public Subnet ID"
  value       = module.networking.public_subnet
}

output "iam_access_Key" {
  description = "IAM User Access Key ID"
  value       = module.iam.iam_access_Key
}

output "iam_access_Key_secrect" {
  description = "IAM User Access Key Secrect"
  value       = module.iam.iam_access_Key_secrect
  sensitive   = true
}