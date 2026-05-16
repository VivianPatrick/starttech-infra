# terraform/main.tf

module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  az_1                 = var.az_1
  az_2                 = var.az_2
  ssh_allowed_cidr     = var.ssh_allowed_cidr
}

module "monitoring" {
  source             = "./modules/monitoring"
  project_name       = var.project_name
  environment        = var.environment
  log_retention_days = 30
  asg_name           = "${var.project_name}-asg"
}

module "compute" {
  source               = "./modules/compute"
  project_name         = var.project_name
  environment          = var.environment
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  public_subnet_id     = module.networking.public_subnet_id
  ec2_sg_id            = module.networking.ec2_sg_id
  iam_instance_profile = module.monitoring.iam_instance_profile_name
}