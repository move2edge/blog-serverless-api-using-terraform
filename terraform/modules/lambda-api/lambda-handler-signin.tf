# terraform/modules/lambda-api/lambda-handler-signin.tf

# This Terraform configuration defines the following AWS resources:
# 1. Lambda Function for Sign-In (aws_lambda_function): Creates a Lambda function for handling user sign-ins.
# 2. Data Source for Sign-In Lambda Code (data "archive_file"): Archives the sign-in Lambda function code into a zip file.
# 3. API Gateway Integration for Sign-In Lambda (aws_apigatewayv2_integration): Creates an integration between API Gateway and the sign-in Lambda function.
# 4. API Gateway Route for Sign-In (aws_apigatewayv2_route): Creates a route in API Gateway for the sign-in endpoint.
# 5. Lambda Permission for API Gateway (aws_lambda_permission): Grants API Gateway permission to invoke the sign-in Lambda function.

resource "aws_lambda_function" "lambda_sign_in" {
  function_name = "${var.lambda_function_name_prefix}-sign-in"
  runtime       = "nodejs18.x"
  handler       = "sign-in-handler.handler"

  role = aws_iam_role.lambda_cognito_admin_role.arn

  filename         = data.archive_file.sign_in_lambda_zip.output_path
  source_code_hash = data.archive_file.sign_in_lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.lambda_deps_layer.arn,
    aws_lambda_layer_version.lambda_utils_layer.arn
  ]

  environment {
    variables = local.shared_env_vars
  }
}

data "archive_file" "sign_in_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/src/handlers/sign-in/"
  output_path = "${path.module}/../../../epicfailure-api/dist/signIn.zip"
}

resource "aws_apigatewayv2_integration" "lambda_sign_in" {
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda_sign_in.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_sign_in" {
  api_id = var.api_gateway_id

  route_key = "POST /sign-in"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_sign_in.id}"
}

resource "aws_lambda_permission" "api_gw_sign_in" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sign_in.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}