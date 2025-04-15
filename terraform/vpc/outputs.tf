output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "region" {
  value = var.region
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = module.vpc.natgw_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "internet_gateway_id" {
  description = "The ID of the Internet gateway"
  value       = module.vpc.igw_id
}

output "internet_gateway_arn" {
  description = "The ID of the Internet gateway"
  value       = module.vpc.igw_arn
}

output "cidr_blocks" {
  value = module.vpc.vpc_cidr_block
}