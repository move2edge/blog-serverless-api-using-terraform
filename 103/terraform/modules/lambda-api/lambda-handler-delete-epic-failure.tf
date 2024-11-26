# terraform/modules/lambda-api/lambda-handler-delete-epic-failure.tf

# This Terraform configuration defines the following AWS resources:
# 1. Lambda Function for Deleting an Epic Failure (aws_lambda_function): Creates a Lambda function for deleting a failure record from DynamoDB.
# 2. Data Source for Delete Epic Failure Lambda Code (data "archive_file"): Archives the delete-epic-failure Lambda function code into a zip file.
# 3. API Gateway Integration for Delete Epic Failure Lambda (aws_apigatewayv2_integration): Creates an integration between API Gateway and the delete-epic-failure Lambda function.
# 4. API Gateway Route for Delete Epic Failure (aws_apigatewayv2_route): Creates a route in API Gateway for the delete-epic-failure endpoint.
# 5. Lambda Permission for API Gateway (aws_lambda_permission): Grants API Gateway permission to invoke the delete-epic-failure Lambda function.

resource "aws_lambda_function" "lambda_delete_epic_failure" {
  function_name    = "${var.lambda_function_name_prefix}-delete-epic-failure"
  runtime          = "nodejs18.x"
  handler          = "delete-epic-failure-handler.handler"
  role             = aws_iam_role.lambda_role_exec.arn
  filename         = data.archive_file.delete_epic_failure_lambda_zip.output_path
  source_code_hash = data.archive_file.delete_epic_failure_lambda_zip.output_base64sha256

  environment {
    variables = local.shared_env_vars
  }
}

data "archive_file" "delete_epic_failure_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../epicfailure-api/dist/handlers/delete-epic-failure-handler.js"
  output_path = "${path.module}/../../../epicfailure-api/dist/deleteEpicFailure.zip"
}

resource "aws_apigatewayv2_integration" "lambda_delete_epic_failure" {
  api_id             = var.api_gateway_id
  integration_uri    = aws_lambda_function.lambda_delete_epic_failure.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "delete_epic_failure" {
  api_id             = var.api_gateway_id
  route_key          = "DELETE /epic-failures"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_delete_epic_failure.id}"
  authorization_type = "JWT"
  authorizer_id      = var.cognito_authorizer_id
}

resource "aws_lambda_permission" "api_gw_delete_epic_failure" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_delete_epic_failure.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway_execution_arn}/*/*"
}