variable "name" {}
variable "cidr" {}

resource "aws_vpc" "milind" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.name}"
  }
}

output "vpc_id" { value = aws_vpc.milind.id }