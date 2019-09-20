variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "ssh_enabled" {
  type        = bool
  description = "Open SSH port 22"
}

variable "app" {
  type         = object({
    release    = string
    name       = string
  })
  description  = "Run application configuration"
}

variable "rabbitmq_endpoint" {
  type        = string
  description = "RabbitMQ endpoint e.g. hostname:port"
}

variable "rabbitmq_credentials" {
  type        = string
  description = "RabbitMQ credentials e.g. username:password"
}
