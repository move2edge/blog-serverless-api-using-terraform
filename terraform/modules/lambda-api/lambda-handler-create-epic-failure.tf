# terraform/modules/lambda-api/lambda-handler-create-epic-failure.tf
# This Terraform configuration defines the following AWS resources:
# 1. Lambda Function for Creating an Epic Failure (aws_lambda_function): Creates a Lambda function for creating a failure record in DynamoDB.
# 2. Data Source for Create Epic Failure Lambda Code (data "archive_file"): Archives the create-epic-failure Lambda function code into a zip file.
# 3. API Gateway Integration for Create Epic Failure Lambda (aws_apigatewayv2_integration): Creates an integration between API Gateway and the create-epic-failure Lambda function.
# 4. API Gateway Route for Create Epic Failure (aws_apigatewayv2_route): Creates a route in API Gateway for the create-epic-failure endpoint.
# 5. Lambda Permission for API Gateway (aws_lambda_permission): Grants API Gateway permission to invoke the create-epic-failure Lambda function.

resource "aws_lambda_function" "lambda_create_epic_failure" {
  function_name = "${var.lambda_function_name_prefix}-create-epic-failure"
  runtime       = "nodejs18.x"
  handler       = "create-epic-failure-handler.handler"

  role = aws_iam_role.lambda_role_exec.arn

  filename         = data.archive_file.create_epic_failure_lambda_zip.output_path
  source_code_hash = data.archive_file.create_epic_failure_lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.lambda_deps_layer.arn,
    aws_lambda_layer_version.lambda_utils_layer.arn
  ]

  environment {
    variables = local.shared_env_vars
  }
}

data "archive_file" "create_epic_failure_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/src/handlers/create-epic-failure/"
  output_path = "${path.module}/../../../epicfailure-api/dist/createEpicFailure.zip"
}

resource "aws_apigatewayv2_integration" "lambda_create_epic_failure" {
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda_create_epic_failure.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_create_epic_failure" {
  api_id = var.api_gateway_id

  route_key = "POST /create-epic-failure"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_create_epic_failure.id}"
  
  authorization_type = "JWT"
  authorizer_id      = var.cognito_authorizer_id
}

resource "aws_lambda_permission" "api_gw_create_epic_failure" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_create_epic_failure.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}