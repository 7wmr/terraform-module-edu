variable "environment" {
  type        = string
  description = "Name of current environment"
}

variable "vpc_id" {
  type        = string
  description = "Name of the VPC id"
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

