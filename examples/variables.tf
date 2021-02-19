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

# Kubernetes RBAC Admin and Developer Users.
variable "users" {
  description = "Kubernetes RBAC Admin and Developer Users."
  type = object({
    admin = list(string)
    developer = list(string)
  })
}