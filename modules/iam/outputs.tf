output "user_names" {
  description = "IAM user names"
  value       = [for user in aws_iam_user.this : user.name]
}

output "group_name" {
  description = "IAM group name"
  value       = aws_iam_group.this.name
}
