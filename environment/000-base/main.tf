module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc.name
  cidr = var.vpc.cidr
  azs  = var.aws.azs

  private_subnets = var.vpc.private_subnets
  private_subnet_tags = {
    Tier = "Private subnet"
  }
  public_subnets = var.vpc.public_subnets
  public_subnet_tags = {
    Tier = "Public subnet"
  }
  enable_nat_gateway   = true
  enable_dns_hostnames = true
}
