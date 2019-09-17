variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}

variable "aws_region" {
  type        = string
  description = "AWS region to be used"
}

variable "rabbitmq" {
  type         = object({
    username   = string 
    password   = string
  })
  description  = "RabbitMQ arguments"
}

