# terraform/variables.tf

# This Terraform configuration defines the following input variables:
# 1. aws_region: The AWS region to deploy resources.
# 2. api_gateway_name: The name of the API Gateway.
# 3. api_gateway_stage_name: The name of the API Gateway Stage.
# 4. dynamo_table_name: The name of the DynamoDB table.

variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "eu-central-1"
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  default     = "epic-failures-apigateway"
}

variable "api_gateway_stage_name" {
  description = "The name of the API Gateway Stage"
  default     = "dev"
}

variable "dynamo_table_name" {
  description = "The name of the DynamoDB table"
  default     = "epic-failures"

}