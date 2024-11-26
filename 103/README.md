# Serverless API on AWS using Terraform

## Init terraform
  
  ```bash
  cd terraform && terraform init
  ```

## Plan terraform

  Try to plan the terraform to see what resources will be created.

  ```bash
  terraform plan
  ```

## Fetch node.js dependencies

  ```bash
  cd epicfailure-api && yarn install
  ```

## Build the node.js project, and deploy using terraform

  ```bash
  cd epicfailure-api && yarn build && yarn deploy
  ```

## Test API

Use environment variables to set your `email`, and `invoke_url` output from the terraform apply command.

```bash
export EMAIL="your-email@example.com"
export INVOKE_URL="https://your-invoke-url-from-terraform-output"
```

### Create Epic Failures

```bash
curl -X POST \
  ${INVOKE_URL}/epic-failures \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -d '{
    "failureID": "001",
    "taskAttempted": "deploying a feature on Friday at 4:59 p.m.",
    "whyItFailed": "triggered a cascade of unexpected errors",
    "lessonsLearned": ["never deploy on a Friday afternoon"]
  }'
```

```bash
curl -X POST \
  ${INVOKE_URL}/epic-failures \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -d '{
    "failureID": "002",
    "taskAttempted": "refactoring the codebase without tests",
    "whyItFailed": "introduced numerous bugs and broke the entire application",
    "lessonsLearned": ["always write tests before refactoring", "never assume the code will work without testing"]
  }'
```

### GET Epic Failures

```bash
curl -X GET \
  ${INVOKE_URL}/epic-failures \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -H "Content-Type: application/json"
```

### DELETE Epic Failure

```bash
curl -X DELETE \
  ${INVOKE_URL}/epic-failures \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "failureID": "001"
  }'
```
