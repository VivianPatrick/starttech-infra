# terraform/modules/monitoring/main.tf

# ─────────────────────────────────────────────
# IAM Role — lets EC2 instances write to CloudWatch
# ─────────────────────────────────────────────
resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "${var.project_name}-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ec2-cloudwatch-role"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# IAM Policy — CloudWatch Logs + Metrics access
# ─────────────────────────────────────────────
resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "${var.project_name}-cloudwatch-policy"
  role = aws_iam_role.ec2_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# ─────────────────────────────────────────────
# IAM Instance Profile — attaches role to EC2
# ─────────────────────────────────────────────
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name

  tags = {
    Name        = "${var.project_name}-ec2-profile"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# CloudWatch Log Group — Backend (Golang API)
# ─────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/starttech/${var.environment}/backend"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-backend-logs"
    Environment = var.environment
    Service     = "backend"
  }
}

# ─────────────────────────────────────────────
# CloudWatch Log Group — Frontend (React/S3)
# ─────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/starttech/${var.environment}/frontend"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-frontend-logs"
    Environment = var.environment
    Service     = "frontend"
  }
}

# ─────────────────────────────────────────────
# CloudWatch Log Group — Application (general)
# ─────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "application" {
  name              = "/starttech/${var.environment}/application"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-application-logs"
    Environment = var.environment
    Service     = "application"
  }
}

# ─────────────────────────────────────────────
# CloudWatch Alarm — High CPU on EC2
# ─────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EC2 CPU utilization exceeded 80%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Name        = "${var.project_name}-high-cpu-alarm"
    Environment = var.environment
  }
}
# ─────────────────────────────────────────────
# SSM Policy — allows EC2 to be managed via
# AWS Systems Manager (used by deploy pipeline)
# ─────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ─────────────────────────────────────────────
# ECR Policy — allows EC2 to pull Docker images
# ─────────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ec2_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}