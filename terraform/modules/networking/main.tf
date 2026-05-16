# terraform/modules/networking/main.tf

# ─────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Internet Gateway
# ─────────────────────────────────────────────
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Public Subnet 1  (AZ-a)
# ─────────────────────────────────────────────
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-1"
    Environment = var.environment
    Type        = "Public"
  }
}

# ─────────────────────────────────────────────
# Public Subnet 2  (AZ-b — required by ALB)
# ─────────────────────────────────────────────
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-2"
    Environment = var.environment
    Type        = "Public"
  }
}

# ─────────────────────────────────────────────
# Private Subnet  (AZ-a)
# ─────────────────────────────────────────────
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az_1

  tags = {
    Name        = "${var.project_name}-private-subnet"
    Environment = var.environment
    Type        = "Private"
  }
}

# ─────────────────────────────────────────────
# Public Route Table (shared by both public subnets)
# ─────────────────────────────────────────────
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ─────────────────────────────────────────────
# Security Group — Application Load Balancer
# ─────────────────────────────────────────────
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Security Group — EC2 / Backend instances
# name_prefix + create_before_destroy allows
# clean replacement without name conflicts
# ─────────────────────────────────────────────
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-sg-"
  description = "Security group for EC2 backend instances"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description     = "App port from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ec2-sg"
    Environment = var.environment
  }
}

# ─────────────────────────────────────────────
# Security Group — ElastiCache Redis
# ─────────────────────────────────────────────
resource "aws_security_group" "redis_sg" {
  name        = "${var.project_name}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Redis from EC2"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-redis-sg"
    Environment = var.environment
  }
}
