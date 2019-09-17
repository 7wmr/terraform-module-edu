variable "mysql" {
  type         = object({
    name       = string
    username   = string
    password   = string
  })
  description  = "MySQL database arguments"
}

