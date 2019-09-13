variable "aws_region" {
  type        = string
  description = "AWS region to be used"
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
