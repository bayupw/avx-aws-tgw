# Aviatrix FireNet Vendor Integration Data Source
data "aviatrix_firenet_vendor_integration" "fw_instance_vendor_integration" {
  provider = aviatrix
  vpc_id        = var.fw_instance_vpc_id
  instance_id   = var.fw_instance_instance_id
  vendor_type   = "Palo Alto Networks VM-Series"
  public_ip     = var.fw_instance_public_ip
  username      = var.admin_api_user
  password      = var.admin_api_password_cleartext
  firewall_name = var.fw_instance_firewall_name
  save          = true
}

output "fw_instance_vendor_integration" {
  value = data.aviatrix_firenet_vendor_integration.fw_instance_vendor_integration
}