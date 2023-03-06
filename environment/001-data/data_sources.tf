data "aws_subnets" "main_db_subnets" {
  tags = {
    UsedBy      = "Main DB"
    Project     = var.layer_metadata.project
    Environment = var.layer_metadata.environment
  }
}

data "aws_vpc" "main_db_vpc" {
  tags = {
    Project     = var.layer_metadata.project
    Environment = var.layer_metadata.environment
  }
}
