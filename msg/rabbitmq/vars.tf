variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "rabbitmq_name" {
  type        = string
  description = "Name of rabbitmq instance to be created."
}

variable "aws_region" {
  type        = string
  description = "AWS region to be used"
}

variable "domain_name" {
  type        = string
  description = "Domain name to be used."
}

variable "rabbitmq" {
  type         = object({
    username   = string 
    password   = string
  })
  description  = "RabbitMQ arguments"
}

