# terraform/modules/lambda-api/variables.tf

# This Terraform configuration defines the following input variables to the lambda-api module:
# 1. aws_region: The AWS region to deploy resources.
# 2. api_gateway_id: The ID of the API Gateway.
# 3. api_gateway_execution_arn: The execution ARN of the API Gateway.
# 4. lambda_function_name_prefix: The prefix for the Lambda function names.

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "api_gateway_id" {
  type = string
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "lambda_function_name_prefix" {
  type = string
}