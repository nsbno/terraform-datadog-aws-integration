data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "backup" {
  bucket = "${data.aws_caller_identity.current.account_id}-datadog-stream-backup"

  // We aren't that scared of loosing the contents of this bucket
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.bucket
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


data "aws_iam_policy_document" "firehose_to_s3" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.backup.arn,
      "${aws_s3_bucket.backup.arn}/*",
    ]
  }
}

resource "aws_iam_role" "firehose_to_s3" {
  path = "/__platform__/"
  name = "datadog-metric-stream-firehose-to-s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "firehose_to_s3" {
  role   = aws_iam_role.firehose_to_s3.name
  policy = data.aws_iam_policy_document.firehose_to_s3.json
}

resource "aws_kinesis_firehose_delivery_stream" "datadog_metric_stream" {
  name        = "datadog-metric-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    name               = "Datadog"
    url                = local.datadog_metric_stream_endpoint
    access_key         = var.datadog_api_key
    buffering_size     = 4
    buffering_interval = 60
    retry_duration     = 60
    s3_backup_mode     = "FailedDataOnly"
    role_arn           = aws_iam_role.firehose_to_s3.arn

    request_configuration {
      content_encoding = "GZIP"
    }

    s3_configuration {
      role_arn            = aws_iam_role.firehose_to_s3.arn
      bucket_arn          = aws_s3_bucket.backup.arn
      error_output_prefix = "datadog_stream"
      buffering_size      = 4
      buffering_interval  = 60
      compression_format  = "GZIP"
    }
  }
}
