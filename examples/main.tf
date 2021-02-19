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
    environment = var.tags.environment
    random = tostring(random_id.id.id)
  }
}

# Create VPC as per requirements
module "vpc" {
  source  = "git@gitlab.wirelessravens.org:f5labs/terraform-aws-vpc-dcec.git"
  aws_vpc_parameters = var.aws_vpc_parameters
  tags = local.tags
}

locals {
  aws_vpc_eks = {
    vpc_id          = module.vpc.vpc_id
    private_subnets  = module.vpc.private_subnets
  }
}

# Create EKS cluster as per requirements
module "eks" {
  source                                   = "git@gitlab.wirelessravens.org:f5labs/terraform-aws-eks-dcec.git"

  admin_users                              = []
  asg_instance_types                       = []
  autoscaling_average_cpu                  = 0
  autoscaling_maximum_size_by_az           = 0
  autoscaling_minimum_size_by_az           = 0
  aws_vpc_eks                              = {}
  developer_users                          = []
  namespaces                               = []
  spot_termination_handler_chart_name      = ""
  spot_termination_handler_chart_namespace = ""
  spot_termination_handler_chart_repo      = ""
  spot_termination_handler_chart_version   = ""
  tags                                     = {}
}
