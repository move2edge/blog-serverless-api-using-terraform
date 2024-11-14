# This Terraform configuration defines the following AWS resources:
# 1. Local Variables (locals): Defines shared environment variables for the module.
# 2. S3 Bucket (aws_s3_bucket): Creates an S3 bucket for storing Lambda functions.
# 3. S3 Bucket Public Access Block (aws_s3_bucket_public_access_block): Configures public access settings for the S3 bucket.
# 4. Data Source for AWS Account Information (data "aws_caller_identity"): Retrieves information about the current AWS account.
# 5. IAM Role for Lambda Execution (aws_iam_role): Creates an IAM role for Lambda execution with the necessary assume role policy.
# 6. IAM Role Policy Attachment (aws_iam_role_policy_attachment): Attaches the AWSLambdaBasicExecutionRole policy to the IAM role.
# 7. IAM Role Policy Attachment for DynamoDB (aws_iam_role_policy_attachment): Attaches a custom policy to the IAM role for Lambda to interact with DynamoDB.
# 8. IAM Role for Lambda with Cognito Admin Permissions (aws_iam_role): Creates an IAM role for Lambda execution with additional permissions for Cognito operations.
# 9. IAM Role Policy Attachment for Cognito Admin Role (aws_iam_role_policy_attachment): Attaches the AWSLambdaBasicExecutionRole policy to the Cognito admin IAM role.
# 10. IAM Role Policy for Cognito Admin Role (aws_iam_role_policy): Defines a custom policy for the Cognito admin IAM role to allow specific Cognito operations.

locals {
  shared_env_vars = {
    USER_POOL_ID         = var.user_pool_id
    COGNITO_CLIENT_ID    = var.user_pool_client_id
    DYNAMODB_TABLE_NAME  = var.dynamo_table_name
  }
}

# S3 Bucket for Lambda functions
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = "epic-failure-terraform-lambda-bucket"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Data source for AWS account information
data "aws_caller_identity" "current" {}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_role_exec" {
  name = "exec-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "IAM policy for Lambda to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamo_table_name}",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_role_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}


# IAM Role for Lambda execution that needs more permissions (sign up and sign in)
resource "aws_iam_role" "lambda_cognito_admin_role" {
  name = "lambda_cognito_admin_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_admin_role_policy" {
  role       = aws_iam_role.lambda_cognito_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_cognito_admin_role_policy" {
  name = "lambda_cognito_admin_role_policy"
  role = aws_iam_role.lambda_cognito_admin_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cognito-idp:SignUp",
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminConfirmSignUp",
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminGetUser", 
        ]
        Effect   = "Allow"
        Resource = [
          "*"
        ]      
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_admin_dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_cognito_admin_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}