locals {
  region      = "us-east-1"
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
      default_tags {
        tags = ${jsonencode(local.tags)}
      }
    }
  EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket                = "666156116058-zealous-iac-terraform-states"
    key                   = "aws-infrastructure-template/${path_relative_to_include()}/terraform.tfstate"
    region                = "us-east-1"
    encrypt               = true
    dynamodb_table        = "zealous-iac-terraform-locks"
    disable_bucket_update = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = {
  tags   = local.tags
  region = local.region
}
