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
  description = "Metrics to include in the Datadog integration. If empty, no metrics will be included. Defaults to include the most common namespaces in production. Check Datadog Metric Collection page for available namespaces."
  nullable    = true
  default     = null
}

variable "metrics_to_stream" {
  type = map(object({
    metric_names = optional(list(string), [])
  }))
  description = "Which metrics you want streamed. Specify the namespace, and optionally, specific metrics to include. Remember to also include value in metrics_to_include. Defaults to only stream in production, and the most relevant namespaces for alerting."
  nullable    = true
  default     = null
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
