# terraform/main.tf

# This root Terraform configuration defines the following AWS resources and modules:
# 1. AWS Provider (provider "aws"): Configures the AWS provider with the specified region and profile.
# 2. API Gateway Module (module "apigateway"): Deploys an API Gateway with the specified settings.
# 3. Lambda API Module (module "lambda-api"): Deploys Lambda functions for API operations, integrates with API Gateway, and DynamoDB.
# 4. DynamoDB Module (module "dynamodb"): Creates a DynamoDB table with the specified settings.

provider "aws" {
  region  = "eu-central-1"
  profile = "move2edge-dev"
}

module "apigateway" {
  source                 = "./modules/apigateway"
  aws_region             = var.aws_region
  api_gateway_name       = var.api_gateway_name
  api_gateway_stage_name = var.api_gateway_stage_name
}

module "lambda-api" {
  source                    = "./modules/lambda-api"
  aws_region                = var.aws_region
  dynamo_table_name         = var.dynamo_table_name
  api_gateway_id            = module.apigateway.api_gateway_id
  api_gateway_execution_arn = module.apigateway.api_gateway_execution_arn
}

module "dynamodb" {
  source            = "./modules/dynamodb"
  aws_region        = var.aws_region
  dynamo_table_name = var.dynamo_table_name
}

