# Cycloid variables
variable "env" {}
variable "project" {}
variable "customer" {}

# AWS variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}
variable "terraform_storage_bucket_name" {}

# Config Repo
variable "git_repository" {}
variable "git_private_key" {}
variable "git_branch" {}

#
# VPC infra module variables
#
variable "cidr" {}
variable "private_subnets" {}
variable "public_subnets" {}

#
# Bastion infra module variables
#
variable "bastion_count" {}
variable "bastion_allowed_networks" {}
variable "bastion_instance_type" {}
variable "keypair_name" {}
# variable "keypair_public" {}