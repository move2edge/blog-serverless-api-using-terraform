# terraform/modules/lambda-api/lambda-shared-layers.tf
# This Terraform configuration defines the following AWS Lambda Layer resources:
# 1. Lambda Layer Version for Dependencies (aws_lambda_layer_version): Creates a Lambda layer for shared dependencies.
# 2. Lambda Layer Version for Utilities (aws_lambda_layer_version): Creates a Lambda layer for shared utilities.
# 3. Data Source for Dependencies Layer Code (data "archive_file"): Archives the dependencies layer code into a zip file.
# 4. Data Source for Utilities Layer Code (data "archive_file"): Archives the utilities layer code into a zip file.

resource "aws_lambda_layer_version" "lambda_deps_layer" {
  layer_name = "shared-deps"

  filename         = data.archive_file.deps_layer_code_zip.output_path
  source_code_hash = data.archive_file.deps_layer_code_zip.output_base64sha256

  compatible_runtimes = ["nodejs18.x"]
}

resource "aws_lambda_layer_version" "lambda_utils_layer" {
  layer_name = "shared-utils"

  filename         = data.archive_file.utils_layer_code_zip.output_path
  source_code_hash = data.archive_file.utils_layer_code_zip.output_base64sha256

  compatible_runtimes = ["nodejs18.x"]
}

data "archive_file" "deps_layer_code_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/layers/deps-layer/"
  output_path = "${path.module}/../../../epicfailure-api/dist/deps.zip"
}

data "archive_file" "utils_layer_code_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../../epicfailure-api/dist/layers/shared-layer/"
  output_path = "${path.module}/../../../epicfailure-api/dist/utils.zip"
}