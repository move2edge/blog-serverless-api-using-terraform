# terraform/variables.tf

# This Terraform configuration defines the following input variables:
# 1. aws_region: The AWS region to deploy resources.
# 2. api_gateway_name: The name of the API Gateway.
# 3. api_gateway_stage_name: The name of the API Gateway Stage.
# 4. dynamo_table_name: The name of the DynamoDB table.
# 5. cognito_user_pool_name: The name of the Cognito User Pool.
# 6. cognito_app_client_name: The name of the Cognito App Client.
# 7. cognito_user_pool_domain: The domain name for the Cognito user pool.

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

variable "cognito_user_pool_name" {
  description = "The name of the Cognito User Pool"
  default     = "epic-failures-user-pool"
}

variable "cognito_app_client_name" {
  description = "The name of the Cognito App Client"
  default     = "epic-failures-app_client"
}


variable "cognito_user_pool_domain" {
  description = "The domain name for the Cognito user pool"
  type        = string
  default     = "epic-failures"
}
