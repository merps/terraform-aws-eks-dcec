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
  source      = "git@gitlab.wirelessravens.org:f5labs/terraform-aws-eks-dcec.git"
  aws_vpc_eks = local.aws_vpc_eks
  namespaces  = var.aws_vpc_parameters.azs
  tags        = local.tags
  users       = var.users
}
