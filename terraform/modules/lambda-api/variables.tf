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