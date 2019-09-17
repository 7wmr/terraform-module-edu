resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "database"
  username             = "${var.mysql.username}"
  password             = "${var.mysql.password}"
  parameter_group_name = "default.mysql5.7"
}

