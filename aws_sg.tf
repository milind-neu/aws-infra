resource "aws_security_group" "application_sg" {

  name   = var.application_sg_name
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.public_route_table_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_route_table_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_route_table_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.public_route_table_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_route_table_cidr]
  }

  tags = {
    Name = var.application_sg_name
  }
}

resource "aws_security_group" "database_sg" {

  name   = var.database_sg_name
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_route_table_cidr]
  }

  tags = {
    Name = var.database_sg_name
  }
}

resource "aws_security_group_rule" "db_from_app" {
  security_group_id        = aws_security_group.database_sg.id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.application_sg.id
}
