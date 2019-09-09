variable "server_port" {
  type        = number
  description = "The instance port"
#  default     = 8080
} 

variable "elb_port" {
  type        = number
  description = "The load balanacer port"
#  default     = 80
}

variable "elb_domain" {
  type        = string
  description = "The domain for the load balancer"
#  default     = "8lr.co.uk"
}

variable "elb_record" {
  type        = string
  description = "The record to be applied to domain"
#  default     = "edu"
}

variable "min_instance_count" {
  type        = number
  description = "Min instances provisioned by ASG"
#  default     = "2"
}

variable "max_instance_count" {
  type        = number
  description = "Max instances provisioned by ASG"
#  default     = "10"
}

