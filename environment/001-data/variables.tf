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

variable "main_db" {
  description = "Main DB configurations"
  type = object({
    name                = string
    family              = string
    engine_version      = string
    tier                = string
    multiaz             = bool
    disk_size           = number
    disk_max_size       = number
    internet_gateway    = bool
    deletion_protection = bool
    backup_retention    = number
    encrypted           = bool
  })
}
