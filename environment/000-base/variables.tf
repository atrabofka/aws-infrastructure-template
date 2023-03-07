variable "layer_metadata" {
  type = object({
    project     = string
    environment = string
    layer       = string
  })
  description = <<-_EOT
  Metadata tp be applied to all layer resources
  {
    project: Name of the project the resources belong to
    environment: Name of the project's environment (e.g. dev, qa etc)
    layer: Name of the layer (e.g. 000-base etc)
  }
  _EOT
}

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
    cidr             = string
    public_subnets   = list(string)
    private_subnets  = list(string)
    database_subnets = list(string)
  })
}
