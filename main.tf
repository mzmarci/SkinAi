module "Bastion" {
  source  = "./modules/ec2"
  ec2_ami = var.ec2_ami
  //ec2_instance_type      = var.ec2_instance_type == "prod" ? "t2.micro" : "t3.medium"
  ec2_instance_type      = var.ec2_instance_type == "prod" ? "t2.micro" : "t2.micro"
  ec2_key_name           = var.ec2_key_name == "prod" ? "test100" : "assign1"
  vpc_security_group_ids = [module.security_group.skinai_security_group_id]
  public_subnets_id      = module.mainvpc.public_subnets_id[*]
  user_data              = file("jenkins_install.sh")


}

module "Ec2" {
  source         = "./modules/ec2-1"
  instance_count = 2 # Create two instances
  ec2_ami        = var.ec2_ami
  //ec2_instance_type      = var.ec2_instance_type == "prod" ? "t2.micro" : "t3.medium"
  ec2_instance_type      = var.ec2_instance_type == "prod" ? "t2.micro" : "t2.micro"
  ec2_key_name           = var.ec2_key_name == "prod" ? "test100" : "assign1"
  vpc_security_group_ids = [module.security_group.skinai_security_group_id]
  private_subnets_id     = module.mainvpc.private_subnets_id[*] # Use private subnets
}

module "mainvpc" {
  source               = "./modules/network"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_cidr             = var.vpc_cidr
  public_subnets_id    = module.mainvpc.public_subnets_id[*]
  private_subnets_id   = module.mainvpc.private_subnets_id[*]
  vpc_id               = module.mainvpc.vpc_id
  tags = {
    Name = "Create VPC"
  }
}

module "security_group" {
  source = "./modules/securitygroup"
  vpc_id = module.mainvpc.vpc_id
}

module "alb_asg" {
  source                 = "./modules/alb"
  ec2_ami                = var.ec2_ami
  ec2_instance_type      = var.ec2_instance_type == "prod" ? "t2.micro" : "t3.medium"
  ec2_key_name           = var.ec2_key_name == "prod" ? "test100" : "assign1"
  public_subnets_id      = module.mainvpc.public_subnets_id[*]
  private_subnets_id     = module.mainvpc.private_subnets_id[*]
  vpc_id                 = module.mainvpc.vpc_id
  ec2_security_group_ids = [module.security_group.skinai_security_group_id]
  alb_name               = "my-app-alb"
  alb_security_group_ids = [module.security_group.skinai_security_group_id]
  instance_tag_name = "my-app-instance"
  target_group_name = "my-app-target-group"
}
