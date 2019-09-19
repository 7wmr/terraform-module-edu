output "endpoint" {
  value = "${aws_instance.rabbitmq.private_ip}:5672"
}
