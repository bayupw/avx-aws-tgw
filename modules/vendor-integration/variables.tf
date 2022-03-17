variable "admin_api_user" {
  type        = string
  default     = "admin-api"
  description = "VM-Series admin API username"
}

# Aviatrix123# cleartext for api-admin
variable "admin_api_password_cleartext" {
  type        = string
  default     = "Aviatrix123#"
  description = "VM-Series admin API password cleartext"
}

variable "fw_instance_vpc_id" {
  type        = string
  description = "Firewall Instance VPC id"
}

variable "fw_instance_instance_id" {
  type        = string
  description = "Firewall instance instance id"
}

variable "fw_instance_public_ip" {
  type        = string
  description = "Firewall instance public IP"
}

variable "fw_instance_firewall_name" {
  type        = string
  description = "Firewall instance name"
}