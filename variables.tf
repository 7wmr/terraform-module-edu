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

variable "min_instance_count" {
  type        = number
  description = "Min instances provisioned by ASG"
}

variable "max_instance_count" {
  type        = number
  description = "Max instances provisioned by ASG"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}
