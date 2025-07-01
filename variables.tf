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

variable "metrics_to_include" {
  type        = list(string)
  description = "Metrics to include in the Datadog integration. If empty, all metrics will be included. Check Datadog Metric Collection page for available namespaces."

  default = []
}

variable "enable_cloudwatch_alarms" {
  type        = bool
  description = "Whether to collect CloudWatch alarms for the Datadog integration."
  default     = false
}

variable "enable_custom_metrics" {
  type        = bool
  description = "Whether to collect custom metrics for the Datadog integration."
  default     = false
}
