variable "mysql" {
  type         = object({
    username   = string
    password   = string
  })
  description  = "MySQL database arguments"
}

variable "cluster_name" {
  type        = string
  description = "Name of cluster to be created."
}
