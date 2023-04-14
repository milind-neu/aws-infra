aws_region  = "us-east-1"
aws_profile = "demo"

vpc_cidr = "10.0.0.0/16"
vpc_name = "demo-vpc"

public_subnet_default  = "Public Subnet"
private_subnet_default = "Private Subnet"

ig_name = "vpc-IG"

public_route_table_cidr  = "0.0.0.0/0"
public_route_table_name  = "Public Route Table"
private_route_table_name = "Private Route Table"

application_sg_name   = "application-sg"
database_sg_name      = "database-sg"
load_balancer_sg_name = "load-balancer-sg"

instance_type     = "t2.micro"
key_name          = "ec2-aws"
volume_size       = 50
volume_type       = "gp2"
aws_instance_name = "application-instance"

db_identifier = "csye6225"
db_username   = "csye6225"
db_password   = "Milind1996"
db_name       = "csye6225"

domain_name = "demo.milindsharma.me"

policy_type                = "SimpleScaling"
adjustment_type            = "ChangeInCapacity"
autoscale_metric_name      = "CPUUtilization"
autoscale_metric_namespace = "AWS/EC2"
ssl_certificate_arn        = "arn:aws:acm:us-east-1:452684689716:certificate/2d672523-a4a6-43d9-8a8b-12345f472d7c"

lt_name = "asg_launch_config"