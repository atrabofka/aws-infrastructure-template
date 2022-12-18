terraform {
  backend "s3" {
    bucket = "aws-infrastructure-template.instigatemobile.com"
    key    = "dev/000-base.tfstate"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }
  required_version = ">= 1.3.6"
}

provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = "dev"
      Project     = "aws-infrastructure-template"
      ManagedBy   = "Terraform"
      Layer       = "000-base"
    }
  }
}
