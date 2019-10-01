output "endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "Endpoint address for mysql instance in address:port format"
}

output "sec_group_id" {
  value = "${aws_security_group.mysql.id}"
}

