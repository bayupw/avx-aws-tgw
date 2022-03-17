# ---------------------------------------------------------------------------------------------------------------------
# Shared Services Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "sharedservices_instance_sg" {
  name        = "shared-services/sg-instance"
  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = module.shared_services.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "shared-services/sg-instance"
  }
}

resource "aws_instance" "sharedservices_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.shared_services.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.sharedservices_instance_sg.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ${var.instance_username}:${var.instance_password} | sudo chpasswd
sudo yum -y install httpd
echo "<p> ${module.shared_services.name} </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
EOF

  tags = {
    Name = "shared-services-instance"
  }
}

resource "aws_instance" "sharedservices_private_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.shared_services.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.sharedservices_instance_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name


  user_data = <<EOF
#!/bin/bash
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ${var.instance_username}:${var.instance_password} | sudo chpasswd
sudo yum -y install httpd
echo "<p> ${module.shared_services.name} </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
EOF

  tags = {
    Name = "shared-services-private-instance"
  }

  depends_on = [module.vendor_integration]
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Production Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "dataprod_instance_sg" {
  name        = "data-prod/sg-instance"
  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = module.data_prod.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "data-prod/sg-instance"
  }
}

resource "aws_instance" "dataprod_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.data_prod.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.dataprod_instance_sg.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ${var.instance_username}:${var.instance_password} | sudo chpasswd
sudo yum -y install httpd
echo "<p> ${module.data_prod.name} </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
EOF

  tags = {
    Name = "data-prod-instance"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Data Production Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "datanonprod_instance_sg" {
  name        = "data-nonprod/sg-instance"
  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = module.data_nonprod.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "data-nonprod/sg-instance"
  }
}

resource "aws_instance" "datanonprod_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.data_nonprod.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.datanonprod_instance_sg.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ${var.instance_username}:${var.instance_password} | sudo chpasswd
sudo yum -y install httpd
echo "<p> ${module.data_nonprod.name} </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
EOF

  tags = {
    Name = "data-nonprod-instance"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# SAP Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "sap_instance_sg" {
  name        = "sap/sg-instance"
  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = module.sap_vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.ingress_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sap/sg-instance"
  }
}

resource "aws_instance" "sap_instance" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  key_name                    = var.key_name
  subnet_id                   = module.sap_vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.sap_instance_sg.id]
  associate_public_ip_address = true

  user_data = <<EOF
#!/bin/bash
sudo sed 's/PasswordAuthentication no/PasswordAuthentication yes/' -i /etc/ssh/sshd_config
sudo systemctl restart sshd
echo ${var.instance_username}:${var.instance_password} | sudo chpasswd
sudo yum -y install httpd
echo "<p> ${module.sap_vpc.name} </p>" >> /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd
EOF

  tags = {
    Name = "sap-instance"
  }
}
