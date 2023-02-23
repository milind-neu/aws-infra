data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_pre_name]
  }
}

resource "aws_instance" "webapp_instance" {
  ami           = data.aws_ami.latest.id
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = 1

  subnet_id                   = module.public_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.application_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }
  disable_api_termination = true

  tags = {
    Name = var.aws_instance_name
  }
}