variable "name" { }
variable "cidrs" { }
variable "vpc_id" { }
variable "subnets" { }

resource "aws_route_table" "private_rt" {
 vpc_id = var.vpc_id
 
 tags = {
   Name = var.name
 }
}

resource "aws_route_table_association" "private_subnet_asso" {
 count = length(var.cidrs)
 subnet_id      = element(var.subnets[*].id, count.index)
 route_table_id = aws_route_table.private_rt.id
}
