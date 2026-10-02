terraform {
  backend "s3" {
    bucket  = "terraform-assignment-backend-ap-south-1"
    key     = "terraform/assignment2/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
