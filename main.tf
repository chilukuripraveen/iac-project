# Root module that instantiates all four child modules.
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  bucket_name  = var.bucket_name
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.vpc.security_group_id
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  key_pair_name     = var.key_pair_name
  desired_capacity  = var.desired_capacity
  min_capacity      = var.min_capacity
  max_capacity      = var.max_capacity
}
