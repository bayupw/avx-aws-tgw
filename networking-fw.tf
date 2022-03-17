module "pan_bootstrap" {
  source = "./modules/bootstrap"
}

# wait for 5 mins after s3 bootstrap files are uploaded, before launching a firewall instance
resource "time_sleep" "wait_bootstrap" {
  create_duration = var.wait_bootstrap
  depends_on      = [module.pan_bootstrap]
}

# Create an AWS VPC
resource "aviatrix_vpc" "networking_fw" {
  cloud_type           = 1
  account_name         = var.aws_account
  region               = var.aws_region
  name                 = "NetworkingFW"
  cidr                 = "10.1.100.0/23"
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
}

# Firenet gateway
resource "aviatrix_transit_gateway" "networking_fw_gw" {
  cloud_type   = 1
  account_name = var.aws_account
  gw_name      = "networking-fw-gw"
  vpc_id       = aviatrix_vpc.networking_fw.vpc_id
  vpc_reg      = var.aws_region
  gw_size      = "c5.xlarge"
  subnet       = aviatrix_vpc.networking_fw.public_subnets[0].cidr
  #ha_subnet                = aviatrix_vpc.dev_transit_vpc.public_subnets[1].cidr
  #ha_gw_size               = "t2.micro"
  enable_hybrid_connection = true
  connected_transit        = true
  single_az_ha             = false
  enable_active_mesh       = true
  enable_firenet           = true

  depends_on = [aviatrix_vpc.networking_fw]
}

resource "aviatrix_aws_tgw_vpc_attachment" "networking_fw_tgw_attachment" {
  tgw_name             = aviatrix_aws_tgw.avx_tgw.tgw_name
  region               = var.aws_region
  security_domain_name = aviatrix_aws_tgw_security_domain.networking_fw_domain.name
  vpc_account_name     = var.aws_account
  vpc_id               = aviatrix_vpc.networking_fw.vpc_id
  depends_on           = [aviatrix_transit_gateway.networking_fw_gw, aviatrix_aws_tgw_security_domain_connection.tgw_connections]
}

# ---------------------------------------------------------------------------------------------------------------------
# Launch Firewall
# ---------------------------------------------------------------------------------------------------------------------
resource "aviatrix_firewall_instance" "networking_fw_instance" {
  vpc_id                = aviatrix_vpc.networking_fw.vpc_id
  firenet_gw_name       = aviatrix_transit_gateway.networking_fw_gw.gw_name
  firewall_name         = "networking-fw-1"
  firewall_image        = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_size         = "m5.xlarge"
  management_subnet     = aviatrix_vpc.networking_fw.subnets[0].cidr
  egress_subnet         = aviatrix_vpc.networking_fw.subnets[1].cidr
  iam_role              = module.pan_bootstrap.aws_iam_role.name
  bootstrap_bucket_name = module.pan_bootstrap.aws_s3_bucket.bucket
  #user_data  = local.networking_fw_init_conf
  depends_on = [aviatrix_transit_gateway.networking_fw_gw, module.pan_bootstrap, time_sleep.wait_bootstrap]
}

# Associate an Aviatrix FireNet Gateway with a Firewall Instance
resource "aviatrix_firewall_instance_association" "networking_fw_instance_assoc" {
  vpc_id               = aviatrix_firewall_instance.networking_fw_instance.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.networking_fw_gw.gw_name
  instance_id          = aviatrix_firewall_instance.networking_fw_instance.instance_id
  firewall_name        = aviatrix_firewall_instance.networking_fw_instance.firewall_name
  lan_interface        = aviatrix_firewall_instance.networking_fw_instance.lan_interface
  management_interface = aviatrix_firewall_instance.networking_fw_instance.management_interface
  egress_interface     = aviatrix_firewall_instance.networking_fw_instance.egress_interface
  attached             = true
}

# Create an Aviatrix FireNet
resource "aviatrix_firenet" "networking_fw_firenet" {
  vpc_id                               = aviatrix_firewall_instance.networking_fw_instance.vpc_id
  inspection_enabled                   = true
  egress_enabled                       = true
  keep_alive_via_lan_interface_enabled = false
  manage_firewall_instance_association = false
  depends_on                           = [aviatrix_firewall_instance_association.networking_fw_instance_assoc]
}

# wait for after firewall instance is launched, before running vendor integration
resource "time_sleep" "wait_fw_instance" {
  create_duration = var.wait_fw_instance
  depends_on      = [aviatrix_firewall_instance.networking_fw_instance]
}

# wait for firewall instance to be created
module "vendor_integration" {
  source                    = "./modules/vendor-integration"
  fw_instance_vpc_id        = aviatrix_firewall_instance.networking_fw_instance.vpc_id
  fw_instance_instance_id   = aviatrix_firewall_instance.networking_fw_instance.instance_id
  fw_instance_public_ip     = aviatrix_firewall_instance.networking_fw_instance.public_ip
  fw_instance_firewall_name = aviatrix_firewall_instance.networking_fw_instance.firewall_name
  depends_on                = [time_sleep.wait_fw_instance]
}