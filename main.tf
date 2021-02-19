data "aws_availability_zones" "available_azs" {
  state = "available"
}

data "aws_caller_identity" "current" {} # used for accesing Account ID and ARN

# render Admin & Developer users list with the structure required by EKS module
locals {
  admin_user_map_users = [
    for admin_user in var.users.admin :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${admin_user}"
      username = admin_user
      groups   = ["system:masters"]
    }
  ]
  developer_user_map_users = [
    for developer_user in var.users.developer :
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${developer_user}"
      username = developer_user
      groups   = ["${var.tags.prefix}-developers"]
    }
  ]
  worker_groups_launch_template = [
    {
      override_instance_types = var.asg.instance_type
      asg_desired_capacity    = var.asg.minimum_size_by_az * length(data.aws_availability_zones.available_azs.zone_ids)
      asg_min_size            = var.asg.minimum_size_by_az * length(data.aws_availability_zones.available_azs.zone_ids)
      asg_max_size            = var.asg.maximum_size_by_az * length(data.aws_availability_zones.available_azs.zone_ids)
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot" # use Spot EC2 instances to save some money and scale more
      public_ip               = true
    },
  ]
}

# create EKS cluster
module "eks-cluster" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "12.1.0"
  cluster_name     = var.tags.prefix
  cluster_version  = "1.16"
  write_kubeconfig = false

  subnets = var.aws_vpc_eks.private_subnets
  vpc_id  = var.aws_vpc_eks.vpc_id

  worker_groups_launch_template = local.worker_groups_launch_template

  # map developer & admin ARNs as kubernetes Users
  map_users = concat(local.admin_user_map_users, local.developer_user_map_users)
}

# get EKS cluster info to configure Kubernetes and Helm providers
data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

# deploy spot termination handler
resource "helm_release" "spot_termination_handler" {
  name       = var.eks_helm_chart.name
  chart      = var.eks_helm_chart.name
  repository = var.eks_helm_chart.repo
  version    = var.eks_helm_chart.version
  namespace  = var.eks_helm_chart.namespace
}

# add spot fleet Autoscaling policy
resource "aws_autoscaling_policy" "eks_autoscaling_policy" {
  count = length(local.worker_groups_launch_template)

  name                   = "${module.eks-cluster.workers_asg_names[count.index]}-autoscaling-policy"
  autoscaling_group_name = module.eks-cluster.workers_asg_names[count.index]
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.asg.average_cpu
  }
}

# create all Namespaces into EKS
resource "kubernetes_namespace" "eks_namespaces" {
  for_each = toset(var.namespaces)

  metadata {
    annotations = {
      name = each.key
    }
    name = each.key
  }
}

# create developers Role using RBAC
resource "kubernetes_cluster_role" "iam_roles_developers" {
  metadata {
    name = "${var.tags.prefix}-developers"
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods", "pods/log", "deployments", "ingresses", "services"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods/exec"]
    verbs      = ["create"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods/portforward"]
    verbs      = ["*"]
  }
}

# bind developer Users with their Role
resource "kubernetes_cluster_role_binding" "iam_roles_developers" {
  metadata {
    name = "${var.tags.prefix}-developers"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${var.tags.prefix}-developers"
  }

  dynamic "subject" {
    for_each = toset(var.users.developer)

    content {
      name      = subject.key
      kind      = "User"
      api_group = "rbac.authorization.k8s.io"
    }
  }
}