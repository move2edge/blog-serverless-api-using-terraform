variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
}

variable "cognito_user_pool_name" {
  description = "The name of the Cognito User Pool"
  type = string
}

variable "cognito_app_client_name" {
  description = "The name of the Cognito App Client"
  type = string
}


variable "cognito_user_pool_domain" {
  description = "The domain name for the Cognito user pool"
  type        = string
}
