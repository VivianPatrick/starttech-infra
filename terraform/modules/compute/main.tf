# terraform/modules/compute/main.tf

resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.ec2_sg_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-cloudwatch-agent
    systemctl enable amazon-cloudwatch-agent
    systemctl start amazon-cloudwatch-agent
  EOF

  tags = {
    Name        = "${var.project_name}-server"
    Environment = var.environment
  }
}