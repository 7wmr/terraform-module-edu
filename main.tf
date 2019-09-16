resource "aws_security_group" "elb" { 
  name = "${var.cluster_name}-secgroup-elb" 

  ingress { 
    from_port   = "${var.elb.port}" 
    to_port     = "${var.elb.port}" 
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

resource "aws_security_group" "web" { 
  name = "${var.cluster_name}-secgroup-web" 
 
  ingress { 
    from_port = "${var.server_port}" 
    to_port = "${var.server_port}" 
    protocol = "tcp" 
    cidr_blocks = [ "0.0.0.0/0" ] 
  } 

  ingress { 
    from_port = "22" 
    to_port = "22" 
    protocol = "tcp" 
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

data "aws_route53_zone" "primary" {
  name         = "${var.elb.domain}."
  private_zone = false
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.cluster_name}.${var.elb.domain}"
  type    = "A"
  
  alias {
    name                   = "${aws_elb.web.dns_name}"
    zone_id                = "${aws_elb.web.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "web" {
  name               = "${var.cluster_name}-elb"
  availability_zones = "${data.aws_availability_zones.available.names}"
  security_groups    = ["${aws_security_group.elb.id}"]
 
  access_logs {
    bucket        = "terraform-edu"
    bucket_prefix = "access-logs"
    interval      = 60
    enabled       = false
  }

  listener {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = "${var.elb.port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.server_port}/api/v1/info"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.cluster_name}-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "web" {
  name = "${var.cluster_name}-${aws_launch_configuration.web.name}"

  launch_configuration       = "${aws_launch_configuration.web.id}"
  availability_zones         = "${data.aws_availability_zones.available.names}"
  health_check_type          = "ELB"
  load_balancers             = [ "${aws_elb.web.name}" ]

  min_size                   = "${var.asg.min_size}"
  max_size                   = "${var.asg.max_size}"
  min_elb_capacity           = "${var.asg.min_size}"
  
  tag { 
    key = "Name" 
    value = "${var.cluster_name}-instance" 
    propagate_at_launch = true 
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" { 
  template = "${file("${path.module}/user-data.sh")}" 
  
  vars = { 
    app_version = var.app_version
  } 
}

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

resource "aws_launch_configuration" "web" { 
  image_id        = "${data.aws_ami.redhat.id}"
  instance_type   = "t2.micro" 
  security_groups = [ "${aws_security_group.web.id}" ] 
  user_data       = "${data.template_file.user_data.rendered}" 
  key_name        = "${var.key_name}"
  lifecycle { 
    create_before_destroy = true 
  } 
}

