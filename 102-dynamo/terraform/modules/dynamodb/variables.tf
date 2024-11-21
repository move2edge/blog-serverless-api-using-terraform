# terraform/modules/dynamodb/variables.tf
# This Terraform configuration defines the following input variables of the module:
# 1. aws_region: The AWS region to deploy resources.
# 2. dynamo_table_name: The name of the Epic Failures DynamoDB table.

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}


variable "dynamo_table_name" {
  description = "The name of the Epic Failures DynamoDB table"
} 