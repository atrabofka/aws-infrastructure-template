include root {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v5.8.1"
}

inputs = {

  aws = {
    region = "us-east-1"
    azs    = ["us-east-1a", "us-east-1b"]
  }

  vpc = {
    cidr_block       = "10.0.0.0/16"
    public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
    database_subnets = ["10.0.5.0/24", "10.0.6.0/24"]
  }
}
