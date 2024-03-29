variable "environment" {
  type        = string
  description = "Name of current environment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet ids"
}

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
    port       = number
  })
  description  = "Web application configuration"
}

variable "elb" {
  type         = object({
    port       = number
    domain     = string
  })
  description  = "Web load balancer configuration"
}

variable "asg" {
  type         = object({
    min_size   = number
    max_size   = number
    enabled    = bool
  })
  description  = "Web auto scaling group configuration"
}

variable "rabbitmq_endpoint" {
  type        = string
  description = "RabbitMQ endpoint e.g. hostname:port"
}

variable "rabbitmq_credentials" {
  type        = string
  description = "RabbitMQ credentials e.g. username:password"
}
