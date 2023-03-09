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
  # Engine
  family         = "postgres12"
  engine_version = "12.12"

  # Instance
  tier                         = "db.t4g.micro"
  performance_insights_enabled = true
  deletion_protection          = true

  # Storage
  disk_size        = "10"
  disk_max_size    = "15"
  encrypted        = true
  backup_retention = 3

  # Network
  internet_gateway = false
  multiaz          = false
}

