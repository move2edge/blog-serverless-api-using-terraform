# terraform/modules/lambda-api/main.tf

# This Terraform configuration defines the following AWS resources:

# 1. Data Source for AWS Account Information (data "aws_caller_identity"): Retrieves information about the current AWS account.
# 2. S3 Bucket (aws_s3_bucket): Creates an S3 bucket for storing Lambda functions.
# 3. S3 Bucket Public Access Block (aws_s3_bucket_public_access_block): This configuration ensures that the S3 bucket lambda_bucket is not publicly accessible by blocking various types of public access settings.
# 4. IAM Role for Lambda Execution (aws_iam_role): Creates an IAM role for Lambda execution with the necessary assume role policy.
# 5. IAM Role Policy Attachment (aws_iam_role_policy_attachment): Attaches the AWSLambdaBasicExecutionRole policy to the IAM role.

# Data source for AWS account information
data "aws_caller_identity" "current" {}

# S3 Bucket for Lambda functions
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "${var.lambda_function_name_prefix}-lambda-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_role_exec" {
  name = "exec-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

