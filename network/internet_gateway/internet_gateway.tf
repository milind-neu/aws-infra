variable "name" {}
variable "vpc_id" {}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.name}"
  }
}

output "ig_id" { value = "${aws_internet_gateway.ig.id}" }