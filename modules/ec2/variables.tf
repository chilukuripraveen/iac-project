variable "project_name" {
  description = "Project name for tagging and naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used by the target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB and ASG"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ALB and EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
}

variable "min_capacity" {
  description = "Minimum number of EC2 instances"
  type        = number
}

variable "max_capacity" {
  description = "Maximum number of EC2 instances"
  type        = number
}
