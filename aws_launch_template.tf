data "template_file" "user_data_sh" {
  template = <<EOF
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

      export PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin

      pm2 kill

      cd /home/ec2-user/webapp
      /home/ec2-user/webapp/node_modules/sequelize-cli/lib/sequelize db:migrate

      echo "enable and start the service"
      systemctl enable pm2-ec2-user.service
      systemctl start pm2-ec2-user.service
      systemctl status pm2-ec2-user.service


      echo "Configuring amazon-cloudwatch-agent"
      sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
        -a fetch-config \
        -m ec2 \
        -c file:/opt/cloudwatch_config.json \
        -s

      sudo systemctl enable amazon-cloudwatch-agent 
      sudo systemctl start amazon-cloudwatch-agent

  EOF 
}

resource "aws_launch_template" "asg_lt" {
  depends_on = [
    aws_db_instance.postgres_instance
  ]

  image_id      = data.aws_ami.latest.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = module.public_subnet.public_subnets[0].id
    security_groups             = [aws_security_group.application_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
      encrypted   = true
    }
  }

  disable_api_termination = false

  tags = {
    Name = var.aws_instance_name
  }

  user_data = base64encode(data.template_file.user_data_sh.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_csye6225_profile.name
  }

}