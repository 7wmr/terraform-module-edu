variable "aws_region" {
  type        = string
  description = "AWS region to be used"
}

variable "server_port" {
  type        = number
  description = "The instance port"
} 

variable "elb_port" {
  type        = number
  description = "The load balanacer port"
}

variable "elb_domain" {
  type        = string
  description = "The domain for the load balancer"
}

variable "asg" {
  type         = map(object({
    min_size   = number
    max_size   = number
  }))

  description  = "Auto scaling group arguments"

  default      = {
    min_size   = null
    max_size   = null
  }
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}
