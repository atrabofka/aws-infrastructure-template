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
      default_tags {
        tags = ${jsonencode(local.tags)}
      }
    }
  EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "666156116058-zealous-iac-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "zealous-iac-terraform-lock"
    disable_bucket_update = true
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
