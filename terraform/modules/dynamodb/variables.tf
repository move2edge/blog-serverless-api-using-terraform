variable "aws_region" {
    description = "The AWS region to deploy resources"
    type = string
}


variable "dynamo_table_name" {
  description = "The name of the Epic Failures DynamoDB table"
}