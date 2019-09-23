resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  port                 = "${var.dbs.port}"
  name                 = "${replace(var.dbs.name, "-", "")}"
  username             = "${var.dbs.username}"
  password             = "${var.dbs.password}"
  publicly_accessible  = true # allowed for testing
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = "true"
  vpc_security_group_ids   = [ "${aws_security_group.mysql.id}" ]
}

provider "mysql" {
  endpoint = "${aws_db_instance.mysql.endpoint}"
  username = "${aws_db_instance.mysql.username}"
  password = "${aws_db_instance.mysql.password}"
}

resource "mysql_database" "dbs" {
  name = "TerraformEdu"
}

resource "aws_security_group" "mysql" {
  name = "${var.dbs.name}-secgroup-mysql"

  ingress {
    from_port   = "${var.dbs.port}" 
    to_port     = "${var.dbs.port}"
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

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


