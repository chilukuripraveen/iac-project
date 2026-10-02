output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.ec2.alb_dns_name
}

output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.s3.bucket_name
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.s3.bucket_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.vpc.security_group_id
}

output "iam_user_names" {
  description = "IAM user names"
  value       = module.iam.user_names
}

output "iam_group_name" {
  description = "IAM group name"
  value       = module.iam.group_name
}
