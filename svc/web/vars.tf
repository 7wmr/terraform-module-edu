
variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "app" {
  type         = object({
    release    = string
    name       = string
    port       = number
  })
  description  = "We application configuration"
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

