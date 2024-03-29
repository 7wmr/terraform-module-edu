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

  security_group_id = "${aws_security_group.rabbitmq.id}"
}

resource "aws_security_group" "rabbitmq" { 
  name = "${var.msg.name}-${var.environment}-secgroup-rabbitmq" 
  vpc_id = "${var.vpc_id}"  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_string" "svc_username" {
  length  = 6
  special = false
  lower   = true
  upper   = false
  number  = false
}

resource "random_password" "svc_password" {
  length = 12
  special = false
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars = {
    adm_username = "${var.msg.username}"
    adm_password = "${var.msg.password}"
    svc_username = "${random_string.svc_username.result}"
    svc_password = "${random_password.svc_password.result}"
  }
}

resource "random_id" "redhat" {
  keepers = {
    ami_id = "${data.aws_ami.redhat.id}"
  }

  byte_length = 3
}

resource "aws_instance" "rabbitmq" {
  ami                    = "${random_id.redhat.keepers.ami_id}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.subnet_id}" 

  user_data              = "${data.template_file.user_data.rendered}" 
  vpc_security_group_ids = ["${aws_security_group.rabbitmq.id}"]
  key_name               = "${var.key_name}"

  tags = {
    Name = "${var.msg.name}-${var.environment}-${random_id.redhat.hex}"
  }
}

#data "aws_route53_zone" "primary" {
#  name         = "${var.msg.domain}."
#  private_zone = false
#}
#
#resource "aws_route53_record" "web" {
#  zone_id = "${data.aws_route53_zone.primary.zone_id}"
#  name    = "${var.msg.name}-${var.environment}.${var.msg.domain}"
#  type    = "A"
#  ttl     = "60"
#  records = ["${aws_instance.rabbitmq.public_ip}"]
#}
