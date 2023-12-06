module "vpc" {
  source = "./modules/vpc"
}

module "s3" {
  source = "./modules/s3"
  code_deploy_role_arn = var.code_deploy_role_arn
  iam_user_arn = var.iam_user_arn
  s3_bucket_name = var.s3_bucket_name
}

module "rds" {
  source        = "./modules/rds"
  db_identifier = var.db_identifier
  db_name       = var.db_name
  db_password   = var.db_password
  db_sg         = [module.vpc.rds_sg.id]
  db_username   = var.db_username
  subnet_list = [module.vpc.subnet_rds_1.id,module.vpc.subnet_rds_2.id]
  ec2_ami       = data.aws_ami.amazon_linux_ami.id
  rds_control_sg = module.vpc.rds_control_sg.id
  rds_control_subnet = module.vpc.subnet_rds_control.id
}

module "redis" {
  source   = "./modules/redis"
  redis_sg = module.vpc.redis_sg.id
  subnet_list = [module.vpc.subnet_redis.id]
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

module "auto_scaling" {
  source         = "./modules/auto_scaling"
  linux_ami_id   = data.aws_ami.amazon_linux_ami.id
  security_group = module.vpc.public_sg.id
  subnet_list = [module.vpc.subnet_auto_scaling_1.id, module.vpc.subnet_auto_scaling_2.id]
  userdata_path  = "userdata.tpl"
  iam_instance_profile_arn = var.iam_instance_profile_arn
}

module "load_balancer" {
  source                  = "./modules/load_balancer"
  auto_scaling_group_name = module.auto_scaling.sg_group.name
  security_group          = module.vpc.elb_sg.id
  subnet_list = [module.vpc.subnet_load_balance_1.id,module.vpc.subnet_load_balance_2.id]
  vpc                     = module.vpc.vpc.id
}

module "code_deploy" {
  source                = "./modules/code_deploy"
  auto_scaling_group_id = module.auto_scaling.sg_group.id
}