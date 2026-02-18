

// Simple example - Using defaults
module "datadog_aws_integration" {
  source = "github.com/nsbno/terraform-datadog-aws-integration?ref=x.y.z"

  team_name = "my-team-name"

  // Make sure environment is production
  // then the commonly used AWS metrics will be included
  environment = "prod"
}

// More advanced - Explicitly specify which Namespaces and Metric Names you want streamed
module "datadog_aws_integration_advanced" {
  source = "github.com/nsbno/terraform-datadog-aws-integration?ref=x.y.z"

  team_name = "my-team-name"

  // Value doesn't matter in this example
  environment = "test"

  metrics_to_include = [
    // Include SNS in DataDog but, we don't need it streamed
    "AWS/SNS",

    // We recommend listing all namespace under metrics_to_stream in metrics_to_include,
    // to avoid confusion with what data is shown in DataDog.
    "AWS/Lambda",
    "AWS/SQS",
    "AWS/ApplicationELB",
  ]

  metrics_to_stream = {
    "AWS/Lambda" = {}
    "AWS/SQS"    = {}

    "AWS/ApplicationELB" = {
      # Will only stream the specified metrics under ApplicationELB
      metric_names = ["HealthyHostCount"]
    },
  }
}