data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
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
      "apigateway:GET",
      "aoss:BatchGetCollection",
      "aoss:ListCollections",
      "autoscaling:Describe*",
      "backup:List*",
      "bcm-data-exports:GetExport",
      "bcm-data-exports:ListExports",
      "bedrock:GetAgent",
      "bedrock:GetAgentAlias",
      "bedrock:GetFlow",
      "bedrock:GetFlowAlias",
      "bedrock:GetGuardrail",
      "bedrock:GetImportedModel",
      "bedrock:GetInferenceProfile",
      "bedrock:GetMarketplaceModelEndpoint",
      "bedrock:ListAgentAliases",
      "bedrock:ListAgents",
      "bedrock:ListFlowAliases",
      "bedrock:ListFlows",
      "bedrock:ListGuardrails",
      "bedrock:ListImportedModels",
      "bedrock:ListInferenceProfiles",
      "bedrock:ListMarketplaceModelEndpoints",
      "bedrock:ListPromptRouters",
      "bedrock:ListProvisionedModelThroughputs",
      "budgets:ViewBudget",
      "cassandra:Select",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codeartifact:DescribeDomain",
      "codeartifact:DescribePackageGroup",
      "codeartifact:DescribeRepository",
      "codeartifact:ListDomains",
      "codeartifact:ListPackageGroups",
      "codeartifact:ListPackages",
      "codedeploy:BatchGet*",
      "codedeploy:List*",
      "codepipeline:ListWebhooks",
      "cur:DescribeReportDefinitions",
      "directconnect:Describe*",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "ec2:Describe*",
      "ec2:GetAllowedImagesSettings",
      "ec2:GetEbsDefaultKmsKeyId",
      "ec2:GetInstanceMetadataDefaults",
      "ec2:GetSerialConsoleAccessStatus",
      "ec2:GetSnapshotBlockPublicAccessState",
      "ec2:GetTransitGatewayPrefixListReferences",
      "ec2:SearchTransitGatewayRoutes",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:List*",
      "emr-containers:ListManagedEndpoints",
      "emr-containers:ListSecurityConfigurations",
      "emr-containers:ListVirtualClusters",
      "es:DescribeElasticsearchDomains",
      "es:ListDomainNames",
      "es:ListTags",
      "events:CreateEventBus",
      "fsx:DescribeFileSystems",
      "fsx:ListTagsForResource",
      "glacier:GetVaultNotifications",
      "glue:ListRegistries",
      "grafana:DescribeWorkspace",
      "greengrass:GetComponent",
      "greengrass:GetConnectivityInfo",
      "greengrass:GetCoreDevice",
      "greengrass:GetDeployment",
      "health:DescribeAffectedEntities",
      "health:DescribeEventDetails",
      "health:DescribeEvents",
      "kinesis:Describe*",
      "kinesis:List*",
      "lambda:GetPolicy",
      "lambda:List*",
      "lightsail:GetInstancePortStates",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:FilterLogEvents",
      "logs:PutSubscriptionFilter",
      "logs:TestMetricFilter",
      "macie2:GetAllowList",
      "macie2:GetCustomDataIdentifier",
      "macie2:ListAllowLists",
      "macie2:ListCustomDataIdentifiers",
      "macie2:ListMembers",
      "macie2:GetMacieSession",
      "managedblockchain:GetAccessor",
      "managedblockchain:GetMember",
      "managedblockchain:GetNetwork",
      "managedblockchain:GetNode",
      "managedblockchain:GetProposal",
      "managedblockchain:ListAccessors",
      "managedblockchain:ListInvitations",
      "managedblockchain:ListMembers",
      "managedblockchain:ListNodes",
      "managedblockchain:ListProposals",
      "memorydb:DescribeAcls",
      "memorydb:DescribeMultiRegionClusters",
      "memorydb:DescribeParameterGroups",
      "memorydb:DescribeReservedNodes",
      "memorydb:DescribeSnapshots",
      "memorydb:DescribeSubnetGroups",
      "memorydb:DescribeUsers",
      "oam:ListAttachedLinks",
      "oam:ListSinks",
      "organizations:Describe*",
      "organizations:List*",
      "osis:GetPipeline",
      "osis:GetPipelineBlueprint",
      "osis:ListPipelineBlueprints",
      "osis:ListPipelines",
      "proton:GetComponent",
      "proton:GetDeployment",
      "proton:GetEnvironment",
      "proton:GetEnvironmentAccountConnection",
      "proton:GetEnvironmentTemplate",
      "proton:GetEnvironmentTemplateVersion",
      "proton:GetRepository",
      "proton:GetService",
      "proton:GetServiceInstance",
      "proton:GetServiceTemplate",
      "proton:GetServiceTemplateVersion",
      "proton:ListComponents",
      "proton:ListDeployments",
      "proton:ListEnvironmentAccountConnections",
      "proton:ListEnvironmentTemplateVersions",
      "proton:ListEnvironmentTemplates",
      "proton:ListEnvironments",
      "proton:ListRepositories",
      "proton:ListServiceInstances",
      "proton:ListServiceTemplateVersions",
      "proton:ListServiceTemplates",
      "proton:ListServices",
      "qldb:ListJournalKinesisStreamsForLedger",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "redshift-serverless:ListEndpointAccess",
      "redshift-serverless:ListManagedWorkgroups",
      "redshift-serverless:ListNamespaces",
      "redshift-serverless:ListRecoveryPoints",
      "redshift-serverless:ListSnapshots",
      "route53:List*",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAccessGrants",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "s3express:GetBucketPolicy",
      "s3express:GetEncryptionConfiguration",
      "s3express:ListAllMyDirectoryBuckets",
      "s3tables:GetTableBucketMaintenanceConfiguration",
      "s3tables:ListTableBuckets",
      "s3tables:ListTables",
      "savingsplans:DescribeSavingsPlanRates",
      "savingsplans:DescribeSavingsPlans",
      "secretsmanager:GetResourcePolicy",
      "ses:Get*",
      "ses:ListAddonInstances",
      "ses:ListAddonSubscriptions",
      "ses:ListAddressLists",
      "ses:ListArchives",
      "ses:ListContactLists",
      "ses:ListCustomVerificationEmailTemplates",
      "ses:ListMultiRegionEndpoints",
      "ses:ListIngressPoints",
      "ses:ListRelays",
      "ses:ListRuleSets",
      "ses:ListTemplates",
      "ses:ListTrafficPolicies",
      "sns:GetSubscriptionAttributes",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "states:DescribeStateMachine",
      "states:ListStateMachines",
      "support:DescribeTrustedAdvisor*",
      "support:RefreshTrustedAdvisorCheck",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "timestream:DescribeEndpoints",
      "timestream:ListTables",
      "waf-regional:GetRule",
      "waf-regional:GetRuleGroup",
      "waf-regional:ListRuleGroups",
      "waf-regional:ListRules",
      "waf:GetRule",
      "waf:GetRuleGroup",
      "waf:ListRuleGroups",
      "waf:ListRules",
      "wafv2:GetIPSet",
      "wafv2:GetLoggingConfiguration",
      "wafv2:GetRegexPatternSet",
      "wafv2:GetRuleGroup",
      "wafv2:ListLoggingConfigurations",
      "workmail:DescribeOrganization",
      "workmail:ListOrganizations",
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

resource "datadog_integration_aws_external_id" "this" {}

data "aws_iam_account_alias" "this" {}


resource "datadog_integration_aws_account" "this" {
  account_tags = [
    "team:${var.team_name}",
    "env:${var.environment}",
    "account-name:${data.aws_iam_account_alias.this.account_alias}"

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
      include_only = var.metrics_to_include
    }
  }

  resources_config {
    cloud_security_posture_management_collection = false
    extended_collection                          = true
  }

  traces_config {
    xray_services {
      include_all = true
    }
  }
}

# resource "datadog_api_key" "datadog_metric_streaming" {
#   count = length(var.metrics_to_stream) > 0 ? 1 : 0
#
#   name = "cloudwatch-metric-stream-${var.environment}-${data.aws_iam_account_alias.this.account_alias}"
# }

module "metric_stream" {
  count  = length(var.metrics_to_stream) > 0 ? 1 : 0
  source = "./modules/metric_stream"

  datadog_api_key    = var.datadog_api_key
  include_namespaces = var.metrics_to_stream
}