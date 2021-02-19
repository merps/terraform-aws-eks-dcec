# AWS VPC EKS infrastructure
variable "aws_vpc_eks" {
  description = "AWS VPC EKS infrastructure for private subnet/vpc deployment"
  type = list(object({
    vpc_id          = string
    private_subnets = list(string)
  }))
}

# AWS IaC Tagging
variable "tags" {
  description = "AWS IaC Tagging"
  type = list(object({
    prefix      = string
    environment = string
    random      = string
  }))
}

# Kubernetes RBAC Admin and Developer Users.
variable "users" {
  description = "Kubernetes RBAC Admin and Developer Users."
  type = list(object({
    admin     = list(string)
    developer = list(string)
  }))
}

# ASG parameters
variable "asg" {
  description = "EC2 AutoScale Parameters"
  default = {
    instance_type      = ["t3.small", "t2.small"]
    minimum_size_by_az = 1
    maximum_size_by_az = 10
    average_cpu        = 30
  }
  type = object({
    instance_type      = list(string)
    minimum_size_by_az = number
    maximum_size_by_az = number
    average_cpu        = number
  })
}

# EKS Spot termination handler Helm
variable "eks_helm_chart" {
  description = "EKS Spot termination handler Helm"
  type = object({
    name      = string
    repo      = string
    version   = string
    namespace = string
  })
  default =
    {
      name      = "aws-node-termination-handler"
      repo      = "https://aws.github.io/eks-charts"
      version   = "0.9.1"
      namespace = "kube-system"
    }
}

# create some variables
variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to be created in our EKS Cluster."
}