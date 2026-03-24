locals {
  // Default to the namespaces we know most people monitor on.
  // Add more if we have missed some key monitors
  default_namespaces = ["AWS/SQS", "AWS/ApplicationELB", "AWS/ApiGateway", "AWS/ECS"]

  // Ugly expression, but wasn't easy to make it pretty
  // 1. When metrics_to_include != null => Always use that
  // 2. When metrics_to_include == null AND environment IS production => Include any popular namespaces
  // 3. When metrics_to_include == null AND environment IS NOT production => Don't include any metrics, to save cost
  metrics_to_include = var.metrics_to_include == null ? (lower(var.environment) == "prod" ? local.default_namespaces : []) : var.metrics_to_include


  // Used later, to select only the default_namespaces that is also mentioned in metrics_to_include
  default_namespaces_intersected_with_metrics_to_include = tolist(setintersection(toset(local.default_namespaces), toset(local.metrics_to_include)))

  //
  // 1. When var.metrics_to_include IS NOT null => Use the intersection between local.metrics_to_include and default_namespaces,
  //                                               to avoid streaming more metrics than strictly necessary but still including those we consider to be important for alerting
  //
  // 2. Otherwise => Include all in default_namespace
  default_namespaces_to_stream = { for ns in(var.metrics_to_include != null ? local.default_namespaces_intersected_with_metrics_to_include : local.default_namespaces) : ns => {} }

  // Also ugly
  // 1. When metrics_to_stream != null => Always use that so the user can override any value
  // 2. When metrics_to_stream == null AND environment IS production AND local.metrics_to_include IS provided => Include the intersection of default_namespace and metrics_to_include
  // 3. When metrics_to_stream == null AND environment IS production AND local.metrics_to_include IS NOT provided => Include all namespaces that are commonly used for Alerts
  // 3. When metrics_to_stream == null AND environment IS NOT production => Don't stream anything to save cost
  metrics_to_stream = var.metrics_to_stream == null ? (lower(var.environment) == "prod" ? local.default_namespaces_to_stream : {}) : var.metrics_to_stream
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["464622532012"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [datadog_integration_aws_external_id.this.id]
    }
  }
}

# This is grabbed from the official docs:
# https://docs.datadoghq.com/integrations/guide/aws-manual-setup/?tab=roledelegation#aws-integration-iam-policy
data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "account:GetAccountInformation",
      "airflow:GetEnvironment",
      "airflow:ListEnvironments",
      "apigateway:GET",
      "appsync:ListGraphqlApis",
      "autoscaling:Describe*",
      "backup:List*",
      "batch:DescribeJobDefinitions",
      "batch:DescribeJobQueues",
      "batch:DescribeJobs",
      "batch:ListJobs",
      "bcm-data-exports:GetExport",
      "bcm-data-exports:ListExports",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrail",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:ListTrails",
      "cloudtrail:LookupEvents",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codebuild:BatchGetProjects",
      "codebuild:ListProjects",
      "codedeploy:BatchGet*",
      "codedeploy:List*",
      "cur:DescribeReportDefinitions",
      "directconnect:Describe*",
      "dms:DescribeReplicationInstances",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:List*",
      "es:DescribeElasticsearchDomains",
      "es:ListDomainNames",
      "es:ListTags",
      "events:CreateEventBus",
      "fsx:DescribeFileSystems",
      "fsx:ListTagsForResource",
      "glue:BatchGetJobs",
      "glue:GetJob",
      "glue:GetJobs",
      "glue:ListJobs",
      "health:DescribeAffectedEntities",
      "health:DescribeEventDetails",
      "health:DescribeEvents",
      "iam:ListAccountAliases",
      "iot:GetV2LoggingOptions",
      "kinesis:Describe*",
      "kinesis:List*",
      "lambda:List*",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeDeliveries",
      "logs:DescribeDeliverySources",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:FilterLogEvents",
      "logs:GetDeliveryDestination",
      "logs:PutSubscriptionFilter",
      "logs:TestMetricFilter",
      "network-firewall:DescribeLoggingConfiguration",
      "network-firewall:ListFirewalls",
      "oam:ListAttachedLinks",
      "oam:ListSinks",
      "organizations:Describe*",
      "organizations:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift-serverless:ListNamespaces",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "route53resolver:ListResolverQueryLogConfigs",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "ses:List*",
      "sns:GetSubscriptionAttributes",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "ssm:GetServiceSetting",
      "ssm:ListCommands",
      "states:DescribeStateMachine",
      "states:ListStateMachines",
      "support:DescribeTrustedAdvisor*",
      "support:RefreshTrustedAdvisorCheck",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "timestream:DescribeEndpoints",
      "trustedadvisor:ListRecommendationResources",
      "trustedadvisor:ListRecommendations",
      "wafv2:ListLoggingConfigurations",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "this" {
  path               = "/__platform__/"
  name               = "datadog-integration-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "this" {
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "security_audit" {
  // https://docs.datadoghq.com/integrations/amazon-web-services/#aws-resource-collection-iam-policy
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  role       = aws_iam_role.this.name
}

resource "datadog_integration_aws_external_id" "this" {}

data "aws_iam_account_alias" "this" {}


resource "datadog_integration_aws_account" "this" {
  account_tags = [
    "team:${var.team_name}",
    "env:${var.environment}",
    "account-name:${data.aws_iam_account_alias.this.account_alias}",
  ]

  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = "aws"

  aws_regions {
    include_only = ["eu-west-1"]
  }

  auth_config {
    aws_auth_config_role {
      role_name   = "${aws_iam_role.this.path}${aws_iam_role.this.name}"
      external_id = datadog_integration_aws_external_id.this.id
    }
  }

  logs_config {
    lambda_forwarder {}
  }

  metrics_config {
    enabled          = true
    automute_enabled = true

    collect_cloudwatch_alarms = var.enable_cloudwatch_alarms
    collect_custom_metrics    = var.enable_custom_metrics

    namespace_filters {
      include_only = local.metrics_to_include
    }
  }

  resources_config {
    cloud_security_posture_management_collection = var.enable_cloud_security
    extended_collection                          = true
  }

  traces_config {
    xray_services {
      include_all = true
    }
  }
}

data "aws_secretsmanager_secret" "metric_stream_datadog" {
  // Managed through observability-service
  // https://github.com/nsbno/observability-service/blob/main/services/datadog-api-setup/infrastructure/datadog_metric_stream_secret.tf
  // Hardcoded value, because the ARN is the same for all environments
  arn = "arn:aws:secretsmanager:eu-west-1:727646359971:secret:datadog_metric_stream_api_key-Bpx7YF"
}

data "aws_secretsmanager_secret_version" "metric_stream_datadog" {
  secret_id = data.aws_secretsmanager_secret.metric_stream_datadog.id
}

module "metric_stream" {
  count  = length(local.metrics_to_stream) > 0 ? 1 : 0
  source = "./modules/metric_stream"

  datadog_api_key    = data.aws_secretsmanager_secret_version.metric_stream_datadog.secret_string
  include_namespaces = local.metrics_to_stream
}