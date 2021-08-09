#
# VPC outputs
#
output "vpc_id" {
  description = "The VPC ID for the VPC"
  value       = module.infra.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR for the VPC"
  value       = module.infra.vpc_cidr
}

output "private_subnets" {
  description = "The private subnets for the VPC"
  value       = module.infra.private_subnets
}

output "public_subnets" {
  description = "The public subnets for the VPC"
  value       = module.infra.public_subnets
}

#
# Bastion outputs
#
output "bastion_ip" {
  description = "The EIP attached to the bastion EC2 server"
  value       = module.infra.bastion_ip
}

output "bastion_user" {
  description = "The username to use to connect to the bastion EC2 server. Set to 'admin' because we use debian OS."
  value       = "admin"
}

output "bastion_sg" {
  description = "The bastion security group ID."
  value       = module.infra.bastion_sg
}

output "bastion_sg_allow" {
  description = "The security group ID to allow SSH traffic from the bastion to the infra instances"
  value       = module.infra.bastion_sg_allow
}