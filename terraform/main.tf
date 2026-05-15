module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"

  vpc_id           = module.networking.vpc_id
  public_subnet_id = module.networking.public_subnet_id
}