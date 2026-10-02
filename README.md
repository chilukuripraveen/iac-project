# AWS Infrastructure with Terraform

This repository provisions a small AWS web application environment using Terraform. The root module composes reusable modules for networking, an S3 bucket, IAM users and group, and an EC2 Auto Scaling Group behind an Application Load Balancer.

## What It Creates

- **VPC:** A VPC with two public and two private subnets across available Availability Zones, an Internet Gateway, a NAT Gateway, and public/private route tables.
- **Network security:** A security group allowing inbound SSH (22), HTTP (80), and HTTPS (443), with unrestricted outbound traffic.
- **Application tier:** An internet-facing Application Load Balancer and an Auto Scaling Group in the public subnets. Instances use the latest matching Amazon Linux 2 AMI by default and install Apache through user data.
- **S3:** A named bucket with versioning enabled, public access blocked, and default AES-256 server-side encryption.
- **IAM:** Three configurable IAM users, a group, and the AWS-managed `AmazonS3ReadOnlyAccess` policy attached to that group. The users are not assigned access keys by this configuration.

The private subnets and NAT Gateway are created for network layout and outbound routing; the current Auto Scaling Group uses the **public** subnets.

## Repository Layout

```text
.
|-- backend.tf              # S3 remote state backend
|-- main.tf                 # Root module composition
|-- provider.tf             # AWS provider configuration
|-- terraform.tf            # Terraform and provider requirements
|-- variables.tf            # Root input variables and defaults
|-- terraform.tfvars        # Example deployment values
|-- outputs.tf              # Root outputs
|-- modules/
	|-- ec2/                # Launch template, ALB, listener, target group, ASG
	|-- iam/                # IAM users, group, and policy attachment
	|-- s3/                 # Encrypted, versioned S3 bucket
	|-- vpc/                # VPC, subnets, routes, NAT, and security group
```

## Requirements

- Terraform 1.5.0 or newer
- An AWS account and credentials available to the AWS provider (for example, an AWS CLI profile or environment credentials)
- Permission to create the AWS resources listed above
- An S3 bucket for Terraform remote state, created before initialization

The backend is configured to use bucket `terraform-assignment-backend-ap-south-1` in `ap-south-1`, with state stored at `terraform/assignment2/terraform.tfstate`. Change `backend.tf` if your state bucket or key differs. Backend settings cannot use normal Terraform input variables.

## Configure

Review `terraform.tfvars` before applying. In particular:

- `bucket_name` must be globally unique across AWS.
- `ami_id` may be left empty to select the latest matching Amazon Linux 2 AMI.
- `key_pair_name` may be left empty, but then SSH key-based access to instances is not configured.
- `desired_capacity`, `min_capacity`, and `max_capacity` control the Auto Scaling Group size.
- `aws_region` selects the deployment region; the backend region is configured separately in `backend.tf`.

Do not put AWS access keys, passwords, or other secrets in `terraform.tfvars` or commit them to this repository. AWS credentials should be supplied through the standard AWS credential chain.

## Deploy

Run these commands from the repository root:

```shell
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```

Terraform will show the planned changes before applying. Review the plan carefully, especially the IAM users and billable networking resources.

## Outputs

After deployment, Terraform reports the load balancer DNS name, S3 bucket name and ARN, VPC and subnet IDs, security group ID, and IAM user and group names. To print the load balancer address directly:

```shell
terraform output -raw alb_dns_name
```

Open `http://<alb_dns_name>` to reach the Apache test page after the instances pass their load balancer health checks.

## Cleanup and Costs

Remove the infrastructure when it is no longer needed:

```shell
terraform destroy
```

The NAT Gateway, Application Load Balancer, EC2 instances, and other provisioned AWS resources may incur charges while they exist. Destroying the stack does not delete the separately configured remote-state bucket.

## Security Notes

This is an example environment, not a production-hardened deployment. The security group currently allows SSH, HTTP, and HTTPS from `0.0.0.0/0`; restrict SSH to trusted source IP ranges and review the web ingress rules before using this configuration in a real environment. The Auto Scaling Group currently places instances in public subnets and enables public IP assignment. Review subnet placement, administrative access, IAM users, and state-bucket permissions for your requirements.