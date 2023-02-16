variable "cidrs" {}
variable "azs" {}
variable "name" {}
variable "vpc_id" {}

resource "aws_subnet" "private_subnet" {
  count             = length(var.cidrs)
  vpc_id            = "${var.vpc_id}"
  cidr_block        = element(var.cidrs, count.index)
  availability_zone = element(var.azs, count.index)


  tags = {
    Name = "${var.name} ${count.index + 1}"
  }
}

output "private_subnets" { value = "${aws_subnet.private_subnet}" }