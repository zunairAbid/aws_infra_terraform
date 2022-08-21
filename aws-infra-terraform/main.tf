module "networking" {
  source           = "./modules/networking"
  global_variables = var.global_variables
  vpc              = var.vpc
}

module "sgs" {
  source            = "./modules/sgs"
  vpc_id            = module.networking.vpc_id
  ec2_sg_cidr_block = module.networking.vpc_cidr
  global_variables  = var.global_variables
}

module "ec2" {
  source            = "./modules/ec2"
  global_variables  = var.global_variables
  security-group-id = module.sgs.instance-sg-id
  subnet_id         = module.networking.public_subnet
  ec2               = var.ec2
}

module "s3" {
  source           = "./modules/s3"
  s3               = var.s3
  global_variables = var.global_variables
}

module "rds" {
  source           = "./modules/rds"
  rds              = var.rds
  subnets          = module.networking.private_subnet
  rds_sg           = module.sgs.rds-sg-id
  global_variables = var.global_variables

}

module "iam" {
  source           = "./modules/iam"
  global_variables = var.global_variables
  s3_bucket_name   = module.s3.s3bucket_name
  iam              = var.iam

}
