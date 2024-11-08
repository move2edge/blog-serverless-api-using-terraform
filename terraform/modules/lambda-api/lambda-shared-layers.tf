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

