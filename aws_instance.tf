data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_pre_name]
  }
}

resource "aws_instance" "webapp_instance" {
  depends_on = [
    aws_db_instance.postgres_instance
  ]

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
  // templatefile("./user_data.tpl", {})
  user_data = <<EOF
      #!/bin/bash

      # Redirect output to a log file
      exec &> /var/log/my-script.log

      echo 'export HOST=${aws_db_instance.postgres_instance.address}' >>/home/ec2-user/.bash_profile     
      echo 'export DB=${var.db_name}' >>/home/ec2-user/.bash_profile
      echo 'export DB_USER=${var.db_username}' >>/home/ec2-user/.bash_profile
      echo 'export PASSWORD=${var.db_password}' >>/home/ec2-user/.bash_profile
      echo 'export S3_REGION=${var.aws_region}' >>/home/ec2-user/.bash_profile
      echo 'export S3_BUCKET_NAME=${aws_s3_bucket.csye6225_s3_bucket.id}' >>/home/ec2-user/.bash_profile

      echo "Setting environment variables"
      source /home/ec2-user/.bash_profile

      echo "Installing Node.js and npm"
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
      . /home/ec2-user/.nvm/nvm.sh
      nvm install 16

      echo "Installing pm2"
      /home/ec2-user/.nvm/versions/node/v16.19.1/bin/npm install -g pm2

      /home/ec2-user/.nvm/versions/node/v16.19.1/bin/pm2 restart webapp
  EOF 

  iam_instance_profile = aws_iam_instance_profile.ec2_csye6225_profile.name
}