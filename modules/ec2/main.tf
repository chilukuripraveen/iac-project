# Lookup Amazon Linux 2 AMI.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id

  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Create a launch template for the EC2 instances.
resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = local.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
    device_index                = 0
  }

  user_data = base64encode(<<-EOT
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "Terraform EC2 Assignment Successful" > /var/www/html/index.html
EOT
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      Name = "${var.project_name}-web"
    })
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-launch-template"
  })
}

# Create a target group for the ALB.
resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path     = "/"
    matcher  = "200"
    port     = "traffic-port"
    protocol = "HTTP"
  }

  tags = merge(local.tags, {
    Name = "${var.project_name}-target-group"
  })
}

# Create an application load balancer.
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  tags = merge(local.tags, {
    Name = "${var.project_name}-alb"
  })
}

# Create an HTTP listener for the ALB.
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# Create an Auto Scaling Group for the instances.
resource "aws_autoscaling_group" "this" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.min_capacity
  max_size                  = var.max_capacity
  desired_capacity          = var.desired_capacity
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.this.arn]
  vpc_zone_identifier       = var.public_subnet_ids
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web"
    propagate_at_launch = true
  }
}
