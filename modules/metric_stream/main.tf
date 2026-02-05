locals {
  datadog_metric_stream_endpoint = "https://awsmetrics-intake.datadoghq.eu/v1/input"
}

resource "aws_iam_role" "metric_streams_to_firehose" {
  path = "/__platform__/"
  name = "datadog-metric-stream-to-firehose"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "streams.metrics.cloudwatch.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "metric_streams_to_firehose" {
  statement {
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]
    resources = [aws_kinesis_firehose_delivery_stream.datadog_metric_stream.arn]
  }
}

resource "aws_iam_role_policy" "metric_streams_to_firehose" {
  role   = aws_iam_role.metric_streams_to_firehose.name
  policy = data.aws_iam_policy_document.metric_streams_to_firehose.json
}

resource "aws_cloudwatch_metric_stream" "push_to_datadog" {
  // We only want metrics to be streamed if
  // var.include_namespace is explicitly mentioned.
  // That is a way to keep the cost low
  count = (length(var.include_namespaces) > 0) ? 1 : 0

  name = "datadog-metric-stream"
  // DataDog metric stream delivery only supports this format
  // Ref. https://docs.datadoghq.com/integrations/guide/aws-cloudwatch-metric-streams-with-kinesis-data-firehose/?tab=awsconsole
  output_format = "opentelemetry0.7"
  firehose_arn  = aws_kinesis_firehose_delivery_stream.datadog_metric_stream.arn
  role_arn      = aws_iam_role.metric_streams_to_firehose.arn

  include_linked_accounts_metrics = false

  dynamic "include_filter" {
    for_each = var.include_namespaces
    content {
      namespace    = include_filter.key
      metric_names = include_filter.value.metric_names
    }
  }
}
