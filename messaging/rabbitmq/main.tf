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
  name = "${var.cluster_name}-secgroup-rabbitmq" 

  # Main port
  ingress { 
    from_port   = "5672" 
    to_port     = "5672" 
    protocol    = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  }

  # Console port
  ingress { 
    from_port   = "15672" 
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
    Name = "${var.cluster_name}-rabbitmq"
  }
}
