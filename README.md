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
| asg | EC2 AutoScale Parameters | <pre>object({<br>    instance_type      = list(string)<br>    minimum_size_by_az = number<br>    maximum_size_by_az = number<br>    average_cpu        = number<br>  })</pre> | <pre>{<br>  "average_cpu": 30,<br>  "instance_type": [<br>    "t3.small",<br>    "t2.small"<br>  ],<br>  "maximum_size_by_az": 10,<br>  "minimum_size_by_az": 1<br>}</pre> | no |
| aws\_vpc\_eks | AWS VPC EKS infrastructure for private subnet/vpc deployment | <pre>object({<br>    vpc_id          = string<br>    private_subnets = list(string)<br>  })</pre> | n/a | yes |
| eks\_helm\_chart | EKS Spot termination handler Helm | <pre>object({<br>    name      = string<br>    repo      = string<br>    version   = string<br>    namespace = string<br>  })</pre> | <pre>{<br>  "name": "aws-node-termination-handler",<br>  "namespace": "kube-system",<br>  "repo": "https://aws.github.io/eks-charts", <br>  "version": "0.9.1"<br>}</pre> | no |
| namespaces | List of namespaces to be created in our EKS Cluster. | `list(string)` | n/a | yes |
| tags | AWS IaC Tagging | <pre>object({<br>    prefix      = string<br>    environment = string<br>    random      = string<br>  })</pre> | n/a | yes |
| users | Kubernetes RBAC Admin and Developer Users. | <pre>object({<br>    admin     = list(string)<br>    developer = list(string)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eks\_cluster | n/a |

