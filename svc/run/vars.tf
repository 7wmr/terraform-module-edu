
variable "app" {
  type         = object({
    release    = string
    name       = string
  })
  description  = "Run application configuration"
}


