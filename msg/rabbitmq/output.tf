output "endpoint" {
  value = "${aws_instance.rabbitmq.private_ip}:5672"
}

output "svc_username" {
  value = "${random_string.svc_username.result}"
}

output "svc_password" {
  value = "${random_password.svc_password.result}"
}
