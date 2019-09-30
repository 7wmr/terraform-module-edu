variable "environment" {
  type        = string
  description = "Name of current environment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}

variable "subnet_id" {
  type        = string
  description = "The subnet idw"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "ssh_enabled" {
  type        = bool
  description = "Open SSH port 22"
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

