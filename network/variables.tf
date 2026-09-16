variable "aws_region" {
  description = "aws region to deploy the resources"
  type = string
  default = "us-east-1"
}

variable "environment_name" {
    description = "Env name used in resource name and tags"
    type = string
    default = "dev"
}

variable "vpc_cidr" {
    description = "CIDR block of vpc. IP address range"
    type = string
    default = "10.0.0.0/16"  
}

variable "tags" {
  description = "global tags to apply to all resources"
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}

variable "subnet_newbits" {
    description = "number of bits to add to vpc CIDR to generate subnets. (e.g. 8 means /24 from /16)"
    type = number
    default = 8
}