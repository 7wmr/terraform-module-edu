data "aws_ami" "redhat" { 
    most_recent = true 
    owners      = [ "309956199498" ] # Redhat 

    filter { 
        name   = "virtualization-type" 
        values = [ "hvm" ] 
    } 
    filter { 
        name   = "architecture" 
        values = [ "x86_64" ] 
    } 
    filter { 
        name   = "image-type" 
        values = [ "machine" ] 
    } 
    filter { 
        name   = "name" 
        values = [ "RHEL-8.0.0_HVM-*-x86_64-1-Hourly2-GP2" ] 
    } 
}

resource "aws_security_group_rule" "ssh" {
  count = "${var.ssh_enabled ? 1 : 0}"
  
  type = "ingress"

  from_port   = "22" 
  to_port     = "22" 
  protocol    = "tcp" 
  cidr_blocks = [ "0.0.0.0/0" ] 

  security_group_id = "${aws_security_group.run.id}"
}

resource "aws_security_group" "run" { 
  name = "${var.app.name}-secgroup-run" 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" { 
  template = "${file("${path.module}/user-data.sh")}" 
  
  vars = { 
    app_version          = "${var.app.release}"
    rabbitmq_endpoint    = "${var.rabbitmq_endpoint}"
    rabbitmq_credentials = "${var.rabbitmq_credentials}"
    mysql_endpoint       = "${var.mysql_endpoint}"
    mysql_credentials    = "${var.mysql_credentials}"
  } 
}

resource "random_id" "redhat" {
  keepers = {
    ami_id = "${data.aws_ami.redhat.id}"
  }

  byte_length = 3
}

resource "aws_instance" "run" {
  ami                    = "${random_id.redhat.keepers.ami_id}"
  instance_type          = "t2.micro"
  
  user_data              = "${data.template_file.user_data.rendered}" 
  vpc_security_group_ids = ["${aws_security_group.run.id}"]
  key_name               = "${var.key_name}"

  tags = {
    Name = "${var.app.name}-${random_id.redhat.hex}"
  }
}


