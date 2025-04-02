terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.58.0"
    }
  }
}