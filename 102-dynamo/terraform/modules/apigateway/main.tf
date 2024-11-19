# terraform/modules/apigateway/main.tf

# This Terraform configuration defines the following AWS resources:
# 1. API Gateway (aws_apigatewayv2_api): Creates an HTTP API Gateway with the specified name.
# 2. API Gateway Stage (aws_apigatewayv2_stage): Creates a deployment stage for the API Gateway with auto-deploy enabled and access logging configured to CloudWatch.
# 3. CloudWatch Log Group (aws_cloudwatch_log_group): Creates a CloudWatch Log Group for storing API Gateway access logs with a retention period of 14 days.

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  name        = var.api_gateway_stage_name
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.cloudwatch.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.api_gateway.name}"

  retention_in_days = 14
}
