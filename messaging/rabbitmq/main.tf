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

resource "aws_security_group" "rabbitmq" { 
  name = "${var.rabbitmq_name}-secgroup-rabbitmq" 

  # SSH port
  ingress { 
    from_port   = "22" 
    to_port     = "22" 
    protocol    = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  }

  # Main port
  ingress { 
    from_port   = "5672" 
    to_port     = "5672" 
    protocol    = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  }

  # Console port
  ingress { 
    from_port   = "80" 
    to_port     = "15672" 
    protocol    = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  }

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
    username = "${var.rabbitmq.username}"
    password = "${var.rabbitmq.password}"
  }
}

resource "aws_instance" "rabbitmq" {
  ami                    = "${data.aws_ami.redhat.id}"
  instance_type          = "t2.micro"
  
  user_data              = "${data.template_file.user_data.rendered}" 
  vpc_security_group_ids = ["${aws_security_group.rabbitmq.id}"]
  key_name               = "${var.key_name}"

  tags = {
    Name = "${var.rabbitmq_name}"
  }
}

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.rabbitmq_name}.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.rabbitmq.public_ip}"]
}


