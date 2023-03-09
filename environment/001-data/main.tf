module "main_db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.1"

  name        = format("%s-maindb", local.resource_prefix)
  description = "Allow ingress to PostgreSQL only within VPC"
  vpc_id      = data.aws_vpc.main_db_vpc.id

  # Ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access within VPC"
      cidr_blocks = data.aws_vpc.main_db_vpc.cidr_block
    },
  ]

  depends_on = [
    data.aws_vpc.main_db_vpc
  ]
}

module "main_db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.2.1"

  identifier = var.main_db.name

  # Database
  engine                              = "postgres"
  engine_version                      = var.main_db.engine_version
  username                            = "vaitalvision"

  # Instance
  instance_class               = var.main_db.tier
  performance_insights_enabled = var.main_db.performance_insights_enabled
  deletion_protection          = var.main_db.deletion_protection

  # Storage
  allocated_storage       = var.main_db.disk_size
  max_allocated_storage   = var.main_db.disk_max_size
  storage_encrypted       = var.main_db.encrypted
  backup_retention_period = var.backup_retention

  # Network
  db_subnet_group_name   = format("%s-%s", var.layer_metadata.project, var.layer_metadata.environment)
  subnet_ids             = data.aws_subnets.main_db_subnets.ids
  multi_az               = var.main_db.multiaz
  vpc_security_group_ids = [module.main_db_security_group.security_group_id]

  # DB Parameter Group
  family = var.main_db.family

  depends_on = [
    module.main_db_security_group,
    data.aws_subnets.main_db_subnets
  ]
}
