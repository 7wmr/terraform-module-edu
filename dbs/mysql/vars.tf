variable "environment" {
  type        = string
  description = "Name of current environment"
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


