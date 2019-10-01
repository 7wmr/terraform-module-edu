output "endpoint" {
  value = "${aws_instance.rabbitmq.private_ip}:5672"
}

output "svc_username" {
  value = "${random_string.svc_username.result}"
}

output "svc_password" {
  value = "${random_password.svc_password.result}"
}

output "sec_group_id" {
  value = "${aws_security_group.rabbitmq.id}"
}

output "port_main" {
  value = 5672 
}

output "port_console" {
  value = 15672
}
