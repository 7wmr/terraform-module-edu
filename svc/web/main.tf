resource "aws_security_group" "elb" { 
  name   = "${var.app.name}-${var.environment}-secgroup-elb" 
  vpc_id = "${var.vpc_id}"  

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

resource "aws_security_group_rule" "ssh" {
  count  = "${var.ssh_enabled ? 1 : 0}"
 
  type = "ingress"

  from_port   = "22" 
  to_port     = "22" 
  protocol    = "tcp" 
  cidr_blocks = [ "0.0.0.0/0" ] 

  security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "elb_web" {
  type                     = "ingress"

  from_port                = "${var.app.port}"
  to_port                  = "${var.app.port}"
  protocol                 = "tcp"

  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.web.id}"
}

resource "aws_security_group" "web" { 
  name   = "${var.app.name}-${var.environment}-secgroup-web" 
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

data "aws_route53_zone" "primary" {
  name         = "${var.elb.domain}."
  private_zone = false
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.app.name}-${var.environment}.${var.elb.domain}"
  type    = "A"
  
  alias {
    name                   = "${aws_elb.web.dns_name}"
    zone_id                = "${aws_elb.web.zone_id}"
    evaluate_target_health = true
  }
}

resource "tls_private_key" "cert" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.cert.private_key_pem}"

  subject {
    common_name  = "${var.app.name}-${var.environment}.${var.elb.domain}"
    organization = "${var.elb.domain}"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_iam_server_certificate" "cert" {
  name             = "${var.app.name}-${var.environment}.${var.elb.domain}"
  certificate_body = "${tls_self_signed_cert.cert.cert_pem}"
  private_key      = "${tls_private_key.cert.private_key_pem}"
}

resource "aws_elb" "web" {
  name               = "${var.app.name}-${var.environment}-elb"
  security_groups    = ["${aws_security_group.elb.id}"]
  subnets            = ["${var.subnet_id}"]

  access_logs {
    bucket        = "terraform-edu"
    bucket_prefix = "access-logs"
    interval      = 60
    enabled       = false
  }

  listener {
    instance_port     = "${var.app.port}"
    instance_protocol = "http"
    lb_port           = "${var.elb.port}"
    lb_protocol       = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.app.port}/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.app.name}-${var.environment}-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "web" {
  count   = "${var.asg.enabled ? 1 : 0}"
  name    = "${var.app.name}-${aws_launch_configuration.web[count.index].name}"

  vpc_zone_identifier        = [ "${var.subnet_id}" ]

  launch_configuration       = "${aws_launch_configuration.web[count.index].id}"
  availability_zone          = "${data.aws_availability_zones.available.names[0]}"
  health_check_type          = "ELB"
  load_balancers             = [ "${aws_elb.web.name}" ]

  min_size                   = "${var.asg.min_size}"
  max_size                   = "${var.asg.max_size}"
  min_elb_capacity           = "${var.asg.min_size}"
  
  tag { 
    key = "Name" 
    value = "${var.app.name}-${random_id.redhat.hex}"

    propagate_at_launch = true 
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "index_tmpl" {
  template = "${file("${path.module}/index.tmpl")}"
  
  vars = {
    app_release   = "${var.app.release}"
    app_timestamp = "${formatdate("DD-MM-YYYY hh:mm", timestamp())}" 
  }
}

data "template_file" "user_data" { 
  template = "${file("${path.module}/user-data.sh")}" 
  
  vars = { 
    app_version          = "${var.app.release}"
    app_port             = "${var.app.port}"
    index_tmpl           = "${data.template_file.index_tmpl.rendered}"
    rabbitmq_endpoint    = "${var.rabbitmq_endpoint}"
    rabbitmq_credentials = "${var.rabbitmq_credentials}"
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

resource "random_id" "redhat" {
  keepers = {
    ami_id = "${data.aws_ami.redhat.id}"
  }

  byte_length = 3
}

resource "aws_launch_configuration" "web" {
  count           = "${var.asg.enabled ? 1 : 0}"
  image_id        = "${random_id.redhat.keepers.ami_id}"
  instance_type   = "t2.micro" 

  security_groups = [ "${aws_security_group.web.id}" ] 
  user_data       = "${data.template_file.user_data.rendered}" 
  key_name        = "${var.key_name}"

  lifecycle { 
    create_before_destroy = true 
  } 
}

resource "aws_instance" "web" {
  count                  = "${var.asg.enabled ? 0 : 1}"
  ami                    = "${random_id.redhat.keepers.ami_id}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.subnet_id}"
  
  user_data              = "${data.template_file.user_data.rendered}" 
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "${var.key_name}"

  tags = {
    Name = "${var.app.name}-${var.environment}-${random_id.redhat.hex}"
  }
}

resource "aws_elb_attachment" "web" {
  count    = "${var.asg.enabled ? 0 : 1}"
  elb      = "${aws_elb.web.id}"
  instance = "${aws_instance.web[count.index].id}"
}
