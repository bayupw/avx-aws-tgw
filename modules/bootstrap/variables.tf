variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS region"
}

variable "aws_iam_role" {
  type        = string
  default     = "bootstrap-VM-S3-role"
  description = "Bootstrap IAM role name"
}

variable "aws_iam_policy" {
  type        = string
  default     = "bootstrap-VM-S3-policy"
  description = "Bootstrap IAM policy"
}

variable "bootstrap_bucket" {
  type        = string
  default     = "pan-bootstrap-bucket"
  description = "Bootstrap S3 bucket name"
}

variable "config_version" {
  type        = string
  default     = "10.1.0"
  description = "Config version"
}

variable "detail_version" {
  type        = string
  default     = "10.1.3"
  description = "Detail version"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "VM-Series admin username"
}

# Aviatrix123# phash for admin
variable "admin_password_phash" {
  type        = string
  default     = "$5$rpbkrfyo$AuahwOgZREF65jNMQpkFW.fFHX0RGbOhLLGsdY7nL/."
  description = "VM-Series admin password phash"
}

variable "admin_public_key" {
  type        = string
  default     = "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFDZzkrT293MlpUVkcxaW01RjBwbE83aFVETlZnRVNZOFNBMThEOUVxWVR1Q3ZobGs3eVIwenBjTEJMNGVmMU02dDJubDZ5SWp0VytlZFhqV0VvTFA3SjRTbHljbjF6RWNBQm93TWVVM00yMFBOTFFMUWdKTlI2QnNsSTBpc1B5U1Yrc092amVYWjlGVFZKMTZrUXhNZjdPTUkzT1ozellNOEsvd0VVcDg5SmFjZmdBMTZHZHN2SWo2dy9lUzZLaVZQbVRWWlNTZmVOendMRGluNDRVbElvcUx5ZkVqS0NQcTUzb0prcyttVSt4eVhsbk9XZVN2Y2FiZ0U1WUJtVy9oamU1QTFOc29WL2s0ellzMzlROXNiODJ0TjhXSkJYN014bWpzUitYMFNaeU8vRWNtNmk1amxpSHB0c256MTRWcDVmTmFXZDJQVUYzNmxlOFdQSStWcXQgdnBjLTBmNjYxYTYyZjgxODEzMzM5X2Z3LWluc3RhbmNlLTE="
  description = "VM-Series admin public-key"
}

variable "admin_api_user" {
  type        = string
  default     = "admin-api"
  description = "VM-Series admin API username"
}

variable "admin_api_profile_name" {
  type        = string
  default     = "Aviatrix-API-Role"
  description = "VM-Series admin API profile name"
}

# Aviatrix123# phash for api-admin
variable "admin_api_password_phash" {
  type        = string
  default     = "$5$wvkrarwn$ySGHsUWRFrKJ6v3nw21sJ842cBkC9CU3k04adOmaY90"
  description = "VM-Series admin API password phash"
}

# Aviatrix123# cleartext for api-admin
variable "admin_api_password_cleartext" {
  type        = string
  default     = "Aviatrix123#"
  description = "VM-Series admin API password cleartext"
}