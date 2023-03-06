provider "aws" {
  region = var.aws.region
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Project     = var.layer_metadata.project
      Environment = var.layer_metadata.environment
      Layer       = var.layer_metadata.layer
    }
  }
}
