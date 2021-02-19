admin_users                              = ["thomas-gray", "ursula-williams"]
developer_users                          = ["melissa-oliver", "lex-oneil"]
asg_instance_types                       = ["t3.small", "t2.small"]
autoscaling_minimum_size_by_az           = 1
autoscaling_maximum_size_by_az           = 10
autoscaling_average_cpu                  = 30
spot_termination_handler_chart_name      = "aws-node-termination-handler"
spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
spot_termination_handler_chart_version   = "0.9.1"
spot_termination_handler_chart_namespace = "kube-system"

tags = { prefix = "f5labs", random = "dcec", environment = "tst" }

aws_vpc = { cidr = "10.0.0.0/16", azs = ["ap-southeast-2a", "ap-southeast-2b"],
region = "ap-southeast-2"}