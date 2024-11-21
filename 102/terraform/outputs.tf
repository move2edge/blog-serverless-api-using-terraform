# terraform/outputs.tf

# This Terraform configuration defines the following output:
# 1. invoke_url: The URL to invoke the API Gateway stage.

output "invoke_url" {
  value = module.apigateway.invoke_url
}