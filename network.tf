module "vpc" {
  source = "./network/vpc"
  name   = var.vpc_name
  cidr   = var.vpc_cidr
}

module "private_subnet" {
  source = "./network/private_subnet"
  cidrs  = local.private_subnet_cidrs
  name   = var.private_subnet_default
  azs    = local.availability_zones
  vpc_id = module.vpc.vpc_id
}

module "public_subnet" {
  source = "./network/public_subnet"
  cidrs  = local.public_subnet_cidrs
  name   = var.public_subnet_default
  azs    = local.availability_zones
  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "./network/internet_gateway"
  name   = var.ig_name
  vpc_id = module.vpc.vpc_id
}

module "private_route_table" {
  source  = "./network/private_route_table"
  cidrs   = local.private_subnet_cidrs
  name    = var.private_route_table_name
  vpc_id  = module.vpc.vpc_id
  subnets = module.private_subnet.private_subnets
}

module "public_route_table" {
  source              = "./network/public_route_table"
  cidrs               = local.public_subnet_cidrs
  name                = var.public_route_table_name
  cidr_block          = var.public_route_table_cidr
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.ig_id
  subnets             = module.public_subnet.public_subnets
}