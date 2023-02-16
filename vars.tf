
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

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}