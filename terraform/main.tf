module "vpc" {
  source = "./modules/vpc"
}

module "s3" {
  source = "./modules/s3"
}

module "rds" {
  source        = "./modules/rds"
  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_password   = var.db_password
  db_sg         = module.vpc.rds_sg.id
  db_username   = var.db_username
  subnet_1      = module.vpc.subnet_rds_1.id
  subnet_2      = module.vpc.subnet_rds_2.id
}

module "redis" {
  source   = "./modules/redis"
  redis_sg = module.vpc.redis_sg.id
  subnet   = module.vpc.subnet_redis.id
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

module "auto_scaling" {
  source         = "./modules/auto_scaling"
  linux_ami_id   = data.aws_ami.amazon_linux.id
  security_group = module.vpc.public_sg.id
  subnet_1       = module.vpc.subnet_auto_scaling_1.id
  subnet_2       = module.vpc.subnet_auto_scaling_2.id
  userdata_path  = "userdata.tpl"
}

module "load_balancer" {
  source                  = "./modules/load_balancer"
  auto_scaling_group_name = module.auto_scaling.sg_group.name
  security_group          = module.vpc.elb_sg.id
  subnet_1                = module.vpc.subnet_load_balance_1.id
  subnet_2                = module.vpc.subnet_load_balance_2.id
  vpc                     = module.vpc.vpc.id
}

module "code_deploy" {
  source                = "./modules/code_deploy"
  auto_scaling_group_id = module.auto_scaling.sg_group.id
}