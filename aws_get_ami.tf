data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_pre_name]
  }
}