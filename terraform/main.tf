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