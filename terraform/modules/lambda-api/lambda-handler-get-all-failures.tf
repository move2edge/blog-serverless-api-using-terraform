# This Terraform configuration defines the following AWS resources:
# 1. Lambda Function for Getting All Failures (aws_lambda_function): Creates a Lambda function for retrieving all failure records from DynamoDB.
# 2. Data Source for Get All Failures Lambda Code (data "archive_file"): Archives the get-all-failures Lambda function code into a zip file.
# 3. API Gateway Integration for Get All Failures Lambda (aws_apigatewayv2_integration): Creates an integration between API Gateway and the get-all-failures Lambda function.
# 4. API Gateway Route for Get All Failures (aws_apigatewayv2_route): Creates a route in API Gateway for the get-all-failures endpoint.
# 5. Lambda Permission for API Gateway (aws_lambda_permission): Grants API Gateway permission to invoke the get-all-failures Lambda function.

resource "aws_lambda_function" "lambda_get_all_failures" {
  function_name = "${var.lambda_function_name_prefix}-get-all-failures"
  runtime       = "nodejs18.x"
  handler       = "get-all-failures-handler.handler"

  role = aws_iam_role.lambda_role_exec.arn

  filename         = data.archive_file.get_all_failures_lambda_zip.output_path
  source_code_hash = data.archive_file.get_all_failures_lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.lambda_deps_layer.arn,
    aws_lambda_layer_version.lambda_utils_layer.arn
  ]

  environment {
    variables = local.shared_env_vars
  }
}

data "archive_file" "get_all_failures_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/src/handlers/get-all-failures/"
  output_path = "${path.module}/../../../epicfailure-api/dist/getAllFailures.zip"
}

resource "aws_apigatewayv2_integration" "lambda_get_all_failures" {
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda_get_all_failures.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_get_all_failures" {
  api_id = var.api_gateway_id

  route_key = "GET /get-all-failures"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_get_all_failures.id}"
  
  authorization_type = "JWT"
  authorizer_id      = var.cognito_authorizer_id
}

resource "aws_lambda_permission" "api_gw_get_all_failures" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_get_all_failures.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}