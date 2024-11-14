# This Terraform configuration defines the following AWS DynamoDB resource:
# 1. DynamoDB Table (aws_dynamodb_table): Creates a DynamoDB table with the specified name, billing mode, hash key, and tags.

resource "aws_dynamodb_table" "epic_failures" {
  name           = "${var.dynamo_table_name}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "failureID"

  attribute {
    name = "failureID"
    type = "S"
  }

  tags = {
    Name = "${var.dynamo_table_name}"
  }
}