# Shared Services
module "shared_services" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "Shared-Services-VPC"
  cidr                 = "10.227.64.0/22"
  azs                  = ["${var.aws_region}a"]
  private_subnets      = ["10.227.64.0/24"]
  public_subnets       = ["10.227.66.0/24"]
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# DataP
module "data_prod" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "Data-Prod-VPC"
  cidr                 = "10.1.0.0/23"
  azs                  = ["${var.aws_region}a"]
  private_subnets      = ["10.1.0.0/24"]
  public_subnets       = ["10.1.1.0/24"]
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# DataNP
module "data_nonprod" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "Data-NonProd-VPC"
  cidr                 = "10.2.0.0/23"
  azs                  = ["${var.aws_region}a"]
  private_subnets      = ["10.2.0.0/24"]
  public_subnets       = ["10.2.1.0/24"]
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# SAP VPC
module "sap_vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 3.0"
  name                 = "SAP-RISE-VPC"
  cidr                 = "10.123.0.0/22"
  azs                  = ["${var.aws_region}a"]
  private_subnets      = ["10.123.0.0/24"]
  public_subnets       = ["10.123.2.0/24"]
  enable_ipv6          = false
  enable_dns_support   = true
  enable_dns_hostnames = true
}


# ---------------------------------------------------------------------------------------------------------------------
# TGW Spoke Attachment
# ---------------------------------------------------------------------------------------------------------------------

resource "aviatrix_aws_tgw_vpc_attachment" "shared_services_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = var.aws_region
  security_domain_name = "Shared_Service_Domain"
  vpc_account_name     = var.aws_account
  vpc_id               = module.shared_services.vpc_id
  depends_on           = [module.shared_services, aviatrix_aws_tgw_security_domain_connection.tgw_connections]

  # ignore changes to allow migration
  lifecycle {
    ignore_changes = all
  }
}

resource "aviatrix_aws_tgw_vpc_attachment" "data_prod_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = var.aws_region
  security_domain_name = "DataP"
  vpc_account_name     = var.aws_account
  vpc_id               = module.data_prod.vpc_id
  depends_on           = [module.data_prod, aviatrix_aws_tgw_security_domain_connection.tgw_connections]

  # ignore changes to allow migration
  lifecycle {
    ignore_changes = all
  }
}

resource "aviatrix_aws_tgw_vpc_attachment" "data_nonprod_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = var.aws_region
  security_domain_name = "DataNP"
  vpc_account_name     = var.aws_account
  vpc_id               = module.data_nonprod.vpc_id
  depends_on           = [module.data_nonprod, aviatrix_aws_tgw_security_domain_connection.tgw_connections]

  # ignore changes to allow migration
  lifecycle {
    ignore_changes = all
  }
}

resource "aviatrix_aws_tgw_vpc_attachment" "sap_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = var.aws_region
  security_domain_name = "SAP"
  vpc_account_name     = var.aws_account
  vpc_id               = module.sap_vpc.vpc_id
  depends_on           = [module.sap_vpc, aviatrix_aws_tgw_security_domain_connection.tgw_connections]

  # ignore changes to allow migration
  lifecycle {
    ignore_changes = all
  }
}