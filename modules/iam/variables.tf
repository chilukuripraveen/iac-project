variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "user_names" {
  description = "List of IAM users to create"
  type        = list(string)
  default     = ["dev-user", "test-user", "admin-user"]
}

variable "group_name" {
  description = "IAM group name"
  type        = string
  default     = "terraform-assignment-group"
}
