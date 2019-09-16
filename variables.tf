variable "aws_region" {
  type        = string
  description = "AWS region to be used"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "app_version" {
  type        = string
  description = "The application version number e.g. v1.0.0"
}

variable "server_port" {
  type        = number
  description = "The instance port"
}

variable "elb" {
  type         = object({
    port       = number
    domain     = string
  })
  description  = "Load balancer arguments"
}

variable "asg" {
  type         = object({
    min_size   = number
    max_size   = number
  })
  description  = "Auto scaling group arguments"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}
