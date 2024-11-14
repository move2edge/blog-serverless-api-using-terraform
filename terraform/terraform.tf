# terraform/terraform.tf
# This Terraform configuration defines the required providers and Terraform version:
# 1. AWS Provider (hashicorp/aws): Specifies the AWS provider with the required version.
# 2. Archive Provider (hashicorp/archive): Specifies the Archive provider with the required version.
# 3. Required Terraform Version: Specifies the required Terraform version for this configuration.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.6.0"
    }
  }

  required_version = "~> 1.9"
}