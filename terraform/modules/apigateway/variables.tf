# terraform/modules/apigateway/variables.tf

# This Terraform configuration defines the following input variables to the apigateway module:
# 1. aws_region: The AWS region to deploy resources.
# 2. api_gateway_name: The name of the API Gateway.
# 3. api_gateway_stage_name: The name of the API Gateway Stage.
# 4. user_pool_id: The ID of the Cognito User Pool.
# 5. user_pool_client_id: The ID of the Cognito User Pool Client.

variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
  
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type = string
}

variable "api_gateway_stage_name" {
  description = "The name of the API Gateway Stage"
  type = string
}

variable "user_pool_id" {
  type = string
}

variable "user_pool_client_id" {
  type = string
}