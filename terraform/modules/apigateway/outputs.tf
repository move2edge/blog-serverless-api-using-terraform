# terraform/modules/apigateway/outputs.tf

# This Terraform configuration defines the following outputs of apigateway module:
# 1. invoke_url: The URL to invoke the API Gateway stage.
# 2. api_gateway_id: The ID of the created API Gateway.
# 3. cognito_authorizer_id: The ID of the configured Cognito authorizer.
# 4. api_gateway_execution_arn: The execution ARN of the created API Gateway.

output "invoke_url" {
  value = aws_apigatewayv2_stage.dev_stage.invoke_url
}

output "api_gateway_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}

output "cognito_authorizer_id" {
  value = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

output "api_gateway_execution_arn" {
  value = aws_apigatewayv2_api.api_gateway.execution_arn
}