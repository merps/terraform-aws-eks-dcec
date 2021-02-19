## Description

Rough draft of Terraform module that provisions EKS in private subnets and deploys helm package manager.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | n/a |
| kubernetes | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_users | List of Kubernetes admins. | `list(string)` | n/a | yes |
| asg\_instance\_types | List of EC2 instance machine types to be used in EKS. | `list(string)` | n/a | yes |
| autoscaling\_average\_cpu | Average CPU threshold to autoscale EKS EC2 instances. | `number` | n/a | yes |
| autoscaling\_maximum\_size\_by\_az | Maximum number of EC2 instances to autoscale our EKS cluster on each AZ. | `number` | n/a | yes |
| autoscaling\_minimum\_size\_by\_az | Minimum number of EC2 instances to autoscale our EKS cluster on each AZ. | `number` | n/a | yes |
| aws\_vpc\_eks | AWS VPC infra | <pre>object({<br>    vpc_id          = string<br>    private_subnets  = list(string)<br>  })</pre> | n/a | yes |
| developer\_users | List of Kubernetes developers. | `list(string)` | n/a | yes |
| namespaces | List of namespaces to be created in our EKS Cluster. | `list(string)` | n/a | yes |
| spot\_termination\_handler\_chart\_name | EKS Spot termination handler Helm chart name. | `string` | n/a | yes |
| spot\_termination\_handler\_chart\_namespace | Kubernetes namespace to deploy EKS Spot termination handler Helm chart. | `string` | n/a | yes |
| spot\_termination\_handler\_chart\_repo | EKS Spot termination handler Helm repository name. | `string` | n/a | yes |
| spot\_termination\_handler\_chart\_version | EKS Spot termination handler Helm chart version. | `string` | n/a | yes |
| tags | tagging | <pre>object({<br>    prefix = string<br>    environment = string<br>    random = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eks\_cluster | n/a |

## References

 * [`medium-deploy-eks-cluster-using-terraform`](https://gitlab.com/nicosingh/medium-deploy-eks-cluster-using-terraform) by [Nico Singh](https://gitlab.com/nicosingh)
