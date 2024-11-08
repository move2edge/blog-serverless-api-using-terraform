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

variable "dynamo_table_name" {
  description = "The name of the DynamoDB table"
  default     = "epic-failures"
  
}

