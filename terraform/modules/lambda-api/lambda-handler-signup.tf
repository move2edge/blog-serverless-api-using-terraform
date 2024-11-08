resource "aws_lambda_function" "lambda_sign_up" {
  function_name = "${var.lambda_function_name_prefix}-sign-up"
  runtime       = "nodejs18.x"
  handler       = "sign-up-handler.handler"

  role = aws_iam_role.lambda_cognito_admin_role.arn

  filename         = data.archive_file.sign_up_lambda_zip.output_path
  source_code_hash = data.archive_file.sign_up_lambda_zip.output_base64sha256

  layers = [
    aws_lambda_layer_version.lambda_deps_layer.arn,
    aws_lambda_layer_version.lambda_utils_layer.arn
  ]

  environment {
    variables = local.shared_env_vars
  }
}

data "archive_file" "sign_up_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/src/handlers/sign-up/"
  output_path = "${path.module}/../../../epicfailure-api/dist/signUp.zip"
}

resource "aws_apigatewayv2_integration" "lambda_sign_up" {
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda_sign_up.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "post_sign_up" {
  api_id = var.api_gateway_id

  route_key = "POST /sign-up"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_sign_up.id}"
}

resource "aws_lambda_permission" "api_gw_sign_up" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sign_up.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}

