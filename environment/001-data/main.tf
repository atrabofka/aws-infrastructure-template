data "aws_subnets" "database_subnets" {
  filter {
    name   = "tag:UsedBy"
    values = ["main_db"]
  }
}

module "main_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.1"

  identifier = var.main_db.name

  # Database
  engine         = "postgres"
  engine_version = var.main_db.engine_version

  # Instance
  instance_class = var.main_db.tier

  # Storage
  allocated_storage     = var.main_db.disk_size
  max_allocated_storage = var.main_db.disk_max_size
  storage_encrypted     = var.main_db.encrypted

  # Network
  subnet_ids = data.aws_subnets.database_subnets.ids
  multi_az   = var.main_db.multiaz

  # DB Parameter Group
  family = var.main_db.family
}

# output "as_is" {
#   value = data.aws_subnets.database_subnets.ids
# }
