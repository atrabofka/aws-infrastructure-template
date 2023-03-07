terraform {
  backend "s3" {
    bucket = "aws-infrastructure-template.instigatemobile.com"
    key    = "dev/001-data.tfstate"
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
