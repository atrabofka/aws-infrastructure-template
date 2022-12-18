variable "aws" {
  description = "AWS configurations"
  type = object({
    region = string
    azs    = list(string)
  })
}

variable "vpc" {
  description = "VPC configurations"
  type = object({
    name             = string
    cidr             = string
    public_subnets   = list(string)
    private_subnets  = list(string)
    database_subnets = list(string)
  })
}
