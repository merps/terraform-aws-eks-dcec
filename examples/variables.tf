variable "aws_vpc_parameters" {
  type = object({
    region  = string
    azs     = list(string)
    cidr    = string
  })
}
variable "tags" {
  type = object({
    prefix = string
    environment = string
    random = string
  })
}
variable "admin_users" {}

variable "developer_users" {}
variable "asg_instance_types" {}
variable "spot_termination_handler_chart_repo" {}
variable "autoscaling_minimum_size_by_az" {}
variable "autoscaling_maximum_size_by_az" {}
variable "autoscaling_average_cpu" {}
variable "spot_termination_handler_chart_name" {}
variable "spot_termination_handler_chart_version" {}
variable "spot_termination_handler_chart_namespace" {}