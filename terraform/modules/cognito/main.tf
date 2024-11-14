# terraform/modules/cognito/main.tf
# This Terraform configuration defines the following AWS Cognito resources:
# 1. Cognito User Pool (aws_cognito_user_pool): Creates a user pool with specified settings including account recovery, verification message template, auto-verified attributes, and password policy.
# 2. Cognito User Pool Domain (aws_cognito_user_pool_domain): Creates a domain for the user pool.
# 3. Cognito User Pool Client (aws_cognito_user_pool_client): Creates a user pool client with specified authentication flows and token validity settings.

resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.cognito_user_pool_name}"
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
  }

  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers = true
    require_symbols = true
  }
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = var.cognito_user_pool_domain
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.cognito_app_client_name}"  
  user_pool_id = aws_cognito_user_pool.user_pool.id

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
  generate_secret = false

  access_token_validity  = 60   
  id_token_validity      = 60   
  refresh_token_validity = 7    

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  } 
}