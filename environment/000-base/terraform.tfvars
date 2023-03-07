layer_metadata = {
  environment = "dev"
  layer       = "000-base"
  project     = "aws-infrastructure-template"
}

vpc = {
  cidr             = "10.145.0.0/16"
  private_subnets  = ["10.145.1.0/24", "10.145.2.0/24"]
  public_subnets   = ["10.145.4.0/24", "10.145.5.0/24"]
  database_subnets = ["10.145.7.0/24", "10.145.8.0/24"]
}

aws = {
  region = "us-west-2"
  # TODO - generate avaliability zones automaticaly from the specified region
  azs = ["us-west-2a", "us-west-2b"]
}
