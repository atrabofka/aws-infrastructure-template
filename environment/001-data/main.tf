module "main_db" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "5.2.1"
  identifier            = var.main_db.name
  engine                = "postgres"
  family                = var.main_db.family
  instance_class        = var.main_db.tier
  allocated_storage     = var.main_db.disk_size
  max_allocated_storage = var.main_db.disk_max_size
  storage_encrypted     = var.main_db.encrypted
}
