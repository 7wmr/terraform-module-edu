output "endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "Endpoint address for mysql instance in address:port format"
}
