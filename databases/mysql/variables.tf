variable "mysql" {
  type         = object({
    username   = string
    password   = string
  })
  description  = "MySQL database arguments"
}

