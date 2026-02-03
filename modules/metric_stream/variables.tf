variable "datadog_api_key" {
  type        = string
  description = "Datadog API key for the metric stream"
  sensitive   = true
}

variable "include_namespaces" {
  type = map(object({
    metric_names = optional(list(string), [])
  }))
  description = "Which metric namespaces, and optionally, specific metrics to include in the stream. If empty, no metrics are included"
  default     = {}
}