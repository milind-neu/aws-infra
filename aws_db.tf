resource "aws_db_parameter_group" "custom_parameter_group" {
  name_prefix = "custom-parameter-group-"
  family      = "postgres14"
  description = "Custom parameter group for postgres 14 database"
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private-subnet-group"
  subnet_ids = [for subnet in module.private_subnet.private_subnets : subnet.id]
}

resource "aws_db_instance" "postgres_instance" {
  identifier             = var.db_identifier
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = 20
  storage_type           = "gp2"
  storage_encrypted      = true
  engine_version         = "14.4"
  parameter_group_name   = aws_db_parameter_group.custom_parameter_group.name
  vpc_security_group_ids = ["${aws_security_group.database_sg.id}"]
  skip_final_snapshot    = true

  multi_az             = false
  db_subnet_group_name = aws_db_subnet_group.private_subnet_group.name
  publicly_accessible  = false
  db_name              = var.db_name
  kms_key_id           = aws_kms_key.rds_cmk.arn
}