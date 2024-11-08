
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