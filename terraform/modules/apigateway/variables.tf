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