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

variable "asg_min_size" {
  type        = number
  description = "Min instances provisioned by ASG"
}

variable "asg_max_size" {
  type        = number
  description = "Max instances provisioned by ASG"
}

variable "asg_args" {
  type         = map
  description  = "Auto scaling group arguments"
  default      = {
    "min_size" = 2
    "max_size" = 10
  }
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}
