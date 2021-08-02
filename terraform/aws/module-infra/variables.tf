# Cycloid
variable "customer" {}
variable "env" {}
variable "project" {}

#
# VPC
#
variable "cidr" {
  type        = string
  description = "The CIDR of the VPC."
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets for the VPC."
  default     = ["10.0.1.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets for the VPC."
  default     = ["10.0.0.0/24"]
}

#
# Bastion
#
variable "bastion_count" {
  description = "Number of bastions to create (use 0 if you want no bastion)"
  default     = 0
}

variable "bastion_allowed_networks" {
  description = "Networks allowed to connect to the bastion using SSH"
  default     = ["0.0.0.0/0"]
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  default     = "t3.micro"
}

variable "keypair_name" {
  description = "The human-readable keypair name to be used for instances deployment"
  default     = ""
}

# variable "keypair_public" {
#   description = "The public SSH key, for SSH access to newly-created instances"
# }

variable "extra_tags" {
  default = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}