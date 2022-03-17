# Aviatrix AWS TGW
resource "aviatrix_aws_tgw" "avx_tgw" {
  account_name                      = var.aws_account
  aws_side_as_number                = "65500"
  manage_vpc_attachment             = false
  manage_transit_gateway_attachment = false
  manage_security_domain            = false
  region                            = var.aws_region
  tgw_name                          = "avx-tgw"
}

# Create Security Domains based on var.tgw_domains
resource "aviatrix_aws_tgw_security_domain" "default_security_domains" {
  for_each   = toset(var.default_security_domains)
  name       = each.value
  tgw_name   = aviatrix_aws_tgw.avx_tgw.tgw_name
  depends_on = [aviatrix_aws_tgw.avx_tgw]
}

# Create Security Domains based on var.tgw_domains
resource "aviatrix_aws_tgw_security_domain" "custom_security_domains" {
  for_each   = toset(var.custom_security_domains)
  name       = each.value
  tgw_name   = aviatrix_aws_tgw.avx_tgw.tgw_name
  depends_on = [aviatrix_aws_tgw.avx_tgw, aviatrix_aws_tgw_security_domain.default_security_domains]
}

# Create Firewall Security Domain
resource "aviatrix_aws_tgw_security_domain" "networking_fw_domain" {
  name              = var.firewall_security_domains[0]
  tgw_name          = aviatrix_aws_tgw.avx_tgw.tgw_name
  aviatrix_firewall = true
  depends_on        = [aviatrix_aws_tgw_security_domain.custom_security_domains]
}

# Create Security Domain Connections
resource "aviatrix_aws_tgw_security_domain_connection" "tgw_connections" {
  for_each     = local.all_connections_map
  tgw_name     = aviatrix_aws_tgw.avx_tgw.tgw_name
  domain_name1 = each.value.domain1
  domain_name2 = each.value.domain2
  depends_on   = [aviatrix_aws_tgw_security_domain.networking_fw_domain]
}

/* 
# TGW VPC Attachment
resource "aviatrix_aws_tgw_vpc_attachment" "avx_spoke_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = local.aws_region_1
  security_domain_name = "Default_Domain"
  vpc_account_name     = local.avx_aws_account
  vpc_id               = module.avx_spoke_vpc.vpc_id
}

# Create an Aviatrix AWS TGW Transit Gateway Attachment
resource "aviatrix_aws_tgw_transit_gateway_attachment" "test_transit_gateway_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = local.aws_region_1
  vpc_account_name     = local.avx_aws_account
  vpc_id               = aviatrix_vpc.transit_vpc.vpc_id
  transit_gateway_name = aviatrix_transit_gateway.transit_gw.gw_name

  depends_on = [aviatrix_transit_gateway.transit_gw]
} */