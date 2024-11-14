# terraform/main.tf

# This root Terraform configuration defines the following AWS resources and modules:
# 1. AWS Provider (provider "aws"): Configures the AWS provider with the specified region and profile.
# 2. API Gateway Module (module "apigateway"): Deploys an API Gateway with the specified settings and integrates with Cognito.
# 3. Cognito Module (module "cognito"): Creates a Cognito User Pool, User Pool Client, and User Pool Domain with the specified settings.
# 4. DynamoDB Module (module "dynamodb"): Creates a DynamoDB table with the specified settings.
# 5. Lambda API Module (module "lambda-api"): Deploys Lambda functions for API operations, integrates with API Gateway, Cognito, and DynamoDB.

provider "aws" {
  region = "eu-central-1"
  profile = "move2edge-dev"
}

module "apigateway" {
  source = "./modules/apigateway"
  aws_region = var.aws_region
  api_gateway_name = var.api_gateway_name
  api_gateway_stage_name = var.api_gateway_stage_name
  user_pool_id = module.cognito.user_pool_id
  user_pool_client_id  = module.cognito.user_pool_client_id
}

module "cognito" {
  source = "./modules/cognito"
  aws_region = var.aws_region
  cognito_user_pool_name = var.cognito_user_pool_name
  cognito_app_client_name = var.cognito_app_client_name
  cognito_user_pool_domain = var.cognito_user_pool_domain 
}

module "dynamodb" {
  source = "./modules/dynamodb"
  aws_region = var.aws_region
  dynamo_table_name = var.dynamo_table_name
}

module "lambda-api" {
  source = "./modules/lambda-api"
  aws_region = var.aws_region
  dynamo_table_name = var.dynamo_table_name
  user_pool_id = module.cognito.user_pool_id
  user_pool_client_id  = module.cognito.user_pool_client_id
  api_gateway_id = module.apigateway.api_gateway_id
  cognito_authorizer_id = module.apigateway.cognito_authorizer_id
  api_gateway_execution_arn = module.apigateway.api_gateway_execution_arn
}