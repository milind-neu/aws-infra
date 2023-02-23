aws_region  = "us-east-1"
aws_profile = "dev"

vpc_cidr = "10.0.0.0/16"
vpc_name = "dev-vpc"

public_subnet_default  = "Public Subnet"
private_subnet_default = "Private Subnet"

ig_name = "vpc-IG"

public_route_table_cidr  = "0.0.0.0/0"
public_route_table_name  = "Public Route Table"
private_route_table_name = "Private Route Table"

sg_name = "application-sg"

instance_type     = "t2.micro"
key_name          = "ec2-aws"
volume_size       = 8
volume_type       = "gp2"
aws_instance_name = "application-instance"