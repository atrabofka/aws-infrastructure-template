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
