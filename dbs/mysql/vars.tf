variable "environment" {
  type        = string
  description = "Name of current environment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id"
}

variable "subnet_group_name" {
  type        = string
  description = "The subnet group name"
}

variable "dbs" {
  type         = object({
    name       = string
    username   = string
    password   = string
    port       = number
  })
  description  = "MySQL database arguments"
}


