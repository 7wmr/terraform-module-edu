variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "msg" {
  type         = object({
    name       = string
    username   = string 
    password   = string
    domain     = string
  })
  description  = "RabbitMQ configuration"
}

