locals {
  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Create three IAM users.
resource "aws_iam_user" "this" {
  for_each = toset(var.user_names)

  name = each.value

  tags = merge(local.tags, {
    Name = each.value
  })
}

# Create an IAM group.
resource "aws_iam_group" "this" {
  name = var.group_name
}

# Add all users to the group.
resource "aws_iam_user_group_membership" "this" {
  for_each = aws_iam_user.this

  user   = each.value.name
  groups = [aws_iam_group.this.name]
}

# Attach the AWS managed S3 read-only policy to the group.
resource "aws_iam_group_policy_attachment" "readonly" {
  group      = aws_iam_group.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
