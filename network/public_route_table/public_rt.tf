variable "name" {}
variable "cidrs" {}
variable "cidr_block" {}
variable "vpc_id" {}
variable "internet_gateway_id" {}
variable "subnets" {}

resource "aws_route_table" "public_rt" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "${var.cidr_block}"
    gateway_id = "${var.internet_gateway_id}"
  }

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.cidrs)
  subnet_id      = element(var.subnets[*].id, count.index)
  route_table_id = "${aws_route_table.public_rt.id}"
}