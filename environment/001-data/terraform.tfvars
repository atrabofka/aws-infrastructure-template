aws = {
  region = "us-west-2"
  # TODO - generate avaliability zones automaticaly from the specified region
  azs = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

main_db = {
  name                = "aws-infrastructure-template"
  family              = "postgres12"
  engine_version      = "12.5"
  tier                = "db.t3.small"
  multiaz             = "false"
  disk_size           = "10"
  disk_max_size       = "15"
  internet_gateway    = false
  deletion_protection = false
  backup_retention    = 3
  encrypted           = false
}

