# terraform/modules/lambda-api/variables.tf
# This Terraform configuration defines the following input variables to the lambda-api module:
# 1. aws_region: The AWS region to deploy resources.
# 2. user_pool_id: The ID of the Cognito User Pool.
# 3. user_pool_client_id: The ID of the Cognito User Pool Client.
# 4. api_gateway_id: The ID of the API Gateway.
# 5. cognito_authorizer_id: The ID of the Cognito authorizer.
# 6. api_gateway_execution_arn: The execution ARN of the API Gateway.
# 7. dynamo_table_name: The name of the DynamoDB table.
# 8. lambda_function_name_prefix: The prefix for the Lambda function names.

variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
}

variable "user_pool_id" {
  type = string
}

variable "user_pool_client_id" {
  type = string
}

variable "api_gateway_id" {
  type = string
}

variable "cognito_authorizer_id" {
  type = string
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "dynamo_table_name" {
  type = string
}

variable "lambda_function_name_prefix" {
  type = string
  default = "epicfailure-api"
}