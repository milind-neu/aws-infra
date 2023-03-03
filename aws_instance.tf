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
  user_data            =  <<EOF
      #!/bin/bash

      # Redirect output to a log file
      exec &> /var/log/user-data-script.log

      cd /home/ec2-user/webapp
      touch .env

      echo 'HOST=${aws_db_instance.postgres_instance.address}' >>/home/ec2-user/webapp/.env
      echo 'DB=${var.db_name}' >>/home/ec2-user/webapp/.env
      echo 'DB_USER=${var.db_username}' >>/home/ec2-user/webapp/.env
      echo 'PASSWORD=${var.db_password}' >>/home/ec2-user/webapp/.env
      echo 'S3_REGION=${var.aws_region}' >>/home/ec2-user/webapp/.env
      echo 'S3_BUCKET_NAME=${aws_s3_bucket.csye6225_s3_bucket.id}' >>/home/ec2-user/webapp/.env

      echo "Installing Node.js and npm"
      yum update -y 
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
      . /home/ec2-user/.nvm/nvm.sh
      nvm install 16

      # Install Sequelize CLI globally
      npm install -g sequelize-cli

      cd /home/ec2-user/webapp
      /home/ec2-user/.nvm/versions/node/v16.19.1/bin/sequelize-cli db:migrate

      echo "reload Systemd configuration files"
      systemctl daemon-reload

      echo "enable and start the service"
      systemctl enable pm2-ec2-user.service
      systemctl start pm2-ec2-user.service
      systemctl status pm2-ec2-user.service

  EOF 

  iam_instance_profile = aws_iam_instance_profile.ec2_csye6225_profile.name 
}