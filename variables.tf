variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used for all resources"
  type        = string
  default     = "terraform-assignment"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances. Leave empty to use the latest Amazon Linux 2 AMI"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
  default     = "terraform-assignment-bucket-20260730"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the ASG"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
  default     = 3
}
