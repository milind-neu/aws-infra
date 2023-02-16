output "vpc_id" {
  description = "ID of the VPC created"
  value = module.vpc.vpc_id
}

output "ig_id" {
  value = module.internet_gateway.ig_id
  description = "ID of the internet gateway created"
}

output "private_subnets" {
  description = "Details of private subnets"
  value = module.private_subnet.private_subnets
}

output "public_subnets" {
  description = "Details of public subnets"
  value = module.public_subnet.public_subnets
}
