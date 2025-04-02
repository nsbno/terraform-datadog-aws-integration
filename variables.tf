variable "team_name" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition     = can(regex("^(dev|test|stage|prod)$", var.environment))
    error_message = "The environment value must be one of: \"dev\", \"test\", \"stage\", \"prod\"."
  }
}
