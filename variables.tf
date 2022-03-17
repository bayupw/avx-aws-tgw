# Learn my public IP
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm*"
}

variable "instance_username" {
  type        = string
  default     = "ec2-user"
  description = "VM admin user"
}

variable "instance_password" {
  type        = string
  default     = "Aviatrix123#"
  description = "VM admin password"
}

variable "aws_account" {
  type        = string
  description = "AWS access account"
}

variable "key_name" {
  type        = string
  description = "ec2 keypair"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "AWS region"
}

variable "ingress_ip" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Ingress CIDR block for EC2 Security Group"
}

variable "wait_bootstrap" {
  type        = string
  default     = "300s"
  description = "Time to wait after the bootstrap is created before launching a firewall instance"
}

variable "wait_fw_instance" {
  type        = string
  default     = "600s"
  description = "Time to wait after the firewall instance is launched"
}

# ---------------------------------------------------------------------------------------------------------------------
# TGW
# ---------------------------------------------------------------------------------------------------------------------

variable "default_security_domains" {
  description = "Default Domain Names"
  default     = ["Default_Domain", "Shared_Service_Domain", "Aviatrix_Edge_Domain"]
}

variable "custom_security_domains" {
  description = "Custom Domain Names"
  default     = ["DataP", "DataNP", "SAP"]
}

variable "firewall_security_domains" {
  description = "Firewall Domain Names"
  default     = ["NetworkingFW"]
}

locals {
  ingress_ip      = "${chomp(data.http.myip.body)}/32" # Client IP for SSH
  avx_aws_account = "AWS-BW"

  rfc1918             = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  ingress_cidr_blocks = concat(local.rfc1918, [local.ingress_ip])

  all_domains = concat(var.default_security_domains, var.custom_security_domains, var.firewall_security_domains)

  #Create connections based on local.fw_domains
  all_connections = flatten([
    for domain in local.all_domains : [
      for connected_domain in slice(local.all_domains, index(local.all_domains, domain) + 1, length(local.all_domains)) : {
        domain1 = domain
        domain2 = connected_domain
      }
    ]
  ])

  #Create map to be used in for_each
  all_connections_map = {
    for connection in local.all_connections : "${connection.domain1}:${connection.domain2}" => connection
  }
}