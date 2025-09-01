locals {
  region = "us-east-1"
  environment = "qa"
  tags = {
    Environment = local.environment
    Application = "aws-infrastructure-template"
    Owner       = "zealops"
    ManagedBy   = "terraform"
    CostCenter  = "Engineering"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "aws" {
      region = "${local.region}"
    }
  EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "666156116058-zealous-iac-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "zealous-iac-terraform-lock"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  tags = local.tags
  region = local.region
}
