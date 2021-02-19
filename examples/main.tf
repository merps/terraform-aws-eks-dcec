# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = ">= 0.12"
}

# Create a random id
resource "random_id" "id" {
  byte_length = 2
}

# Create Local object for modules
locals {
  tags = {
    prefix = tostring("${var.tags.prefix}-${var.tags.environment}")
    env    = var.tags.environment
    random = tostring(random_id.id.id)
  }
}

# Create VPC as per requirements
module "vpc" {
  source  = "git@gitlab.wirelessravens.org:f5labs/f5-cwl-telegraf.git//src/modules/awsInfra/vpc"
  aws_vpc_parameters = var.aws_vpc_parameters
  tags = var.tags
}

locals {
  aws_vpc_eks = {
    vpc_id          = module.vpc.vpc_id
    private_subnets  = module.vpc.private_subnets
  }
}

# Create EKS cluster as per requirements
module "eks" {
  source                                   = "../"
  admin_users                              = var.admin_users
  asg_instance_types                       = var.asg_instance_types
  autoscaling_average_cpu                  = var.autoscaling_average_cpu
  autoscaling_maximum_size_by_az           = var.autoscaling_maximum_size_by_az
  autoscaling_minimum_size_by_az           = var.autoscaling_minimum_size_by_az
  aws_vpc_eks                              = local.aws_vpc_eks
  tags                                     = var.tags
  developer_users                          = var.developer_users
  namespaces                               = var.aws_vpc_parameters.azs
  spot_termination_handler_chart_name      = var.spot_termination_handler_chart_name
  spot_termination_handler_chart_namespace = var.spot_termination_handler_chart_namespace
  spot_termination_handler_chart_repo      = var.spot_termination_handler_chart_repo
  spot_termination_handler_chart_version   = var.spot_termination_handler_chart_version
}
