
variable "aws_profile" {
  type        = string
  description = "AWS profile selected (DEMO / DEV)"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR to assign to the VPC"
}
variable "vpc_name" {
  type        = string
  description = "Name of VPC"
}

variable "public_subnet_default" {
  type        = string
  description = "Name of Public subnet"
}
variable "private_subnet_default" {
  type        = string
  description = "Name of Private subnet"
}

variable "ig_name" {
  type        = string
  description = "Name of internet gateway"
}

variable "public_route_table_cidr" {
  type        = string
  description = "CIDR block for public route table"
  default     = "0.0.0.0/0"
}
variable "public_route_table_name" {
  type        = string
  description = "Name of Public route table"
}

variable "private_route_table_name" {
  type        = string
  description = "Name of Private route table"
}

variable "aws_region" {
  type        = string
  description = "AWS Deployment region"
  default     = "us-east-1"
}

variable "ami_pre_name" {
  type    = string
  default = "csye6225_*"
}

variable "sg_name" {
  type        = string
  description = "Security group name"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Name of key created using ssh "
}

variable "volume_size" {
  type        = number
  description = "Volume size"
}

variable "volume_type" {
  type        = string
  description = "Volume type"
}

variable "aws_instance_name" {
  type        = string
  description = "Name of instance"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "cidr_ab_subnet" {
  type    = string
  default = "10.0"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_c_private_subnets = 1
  cidr_c_public_subnets  = 64
  max_subnets            = 3
}

locals {
  private_subnet_cidrs = [
    for az in local.availability_zones :
    "${var.cidr_ab_subnet}.${local.cidr_c_private_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_subnets
  ]

  public_subnet_cidrs = [
    for az in local.availability_zones :
    "${var.cidr_ab_subnet}.${local.cidr_c_public_subnets + index(local.availability_zones, az)}.0/24"
    if index(local.availability_zones, az) < local.max_subnets
  ]
}