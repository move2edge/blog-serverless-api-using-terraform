
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