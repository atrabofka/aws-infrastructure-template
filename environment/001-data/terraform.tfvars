layer_metadata = {
  environment = "dev"
  layer       = "001-data"
  project     = "aws-infrastructure-template"
}

aws = {
  region = "us-west-2"
  # TODO - generate avaliability zones automaticaly from the specified region
  azs = ["us-west-2a", "us-west-2b"]
}

main_db = {
  name                = "aws-infrastructure-template"
  family              = "postgres12"
  engine_version      = "12.12"
  tier                = "db.t4g.micro"
  multiaz             = false
  disk_size           = "10"
  disk_max_size       = "15"
  internet_gateway    = false
  deletion_protection = false
  backup_retention    = 3
  encrypted           = false
}

