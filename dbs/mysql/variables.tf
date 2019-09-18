variable "mysql" {
  type         = object({
    name       = string
    username   = string
    password   = string
    port       = number
  })
  description  = "MySQL database arguments"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}


