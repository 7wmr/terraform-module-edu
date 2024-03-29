resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = "${var.dbs.port}"
  name                   = "${var.dbs.name}${var.environment}"
  username               = "${var.dbs.username}"
  password               = "${var.dbs.password}"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = "true"
  vpc_security_group_ids = [ "${aws_security_group.mysql.id}" ]
  db_subnet_group_name   = "${var.subnet_group_name}" 
}

resource "aws_security_group" "mysql" {
  name   = "${var.dbs.name}-${var.environment}-secgroup-mysql"
  vpc_id = "${var.vpc_id}" 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
