output "rabbitmq_hostname" {
  value = "${aws_instance.rabbitmq.private_dns}"
}
