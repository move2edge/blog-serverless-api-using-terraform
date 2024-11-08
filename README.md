# Terraform Serverless Rest API

## Init terraform
  
  ```bash
  cd terraform && terraform init
  ```

## Plan terraform
  Try to plan the terraform to see what resources will be created.

  ```bash
  cd terraform && terraform plan
  ```

## Fetch node.js dependencies
  ```bash
  cd epicfailure-api && yarn install
  ```

## Build the node.js project, package and deploy using terraform
  ```bash
  cd epicfailure-api && yarn yarn package-build-and-deploy
  ```

## Test API

Use environment variables to set your email, and invoke_url output from the terraform apply command.


```bash
export EMAIL="your-email@example.com"
export INVOKE_URL="https://your-invoke-url-from-terraform-output"
```

### Sign up
```bash
curl -X POST \
  ${INVOKE_URL}/sign-up \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"${EMAIL}"'",   
    "password": "Password123!",
    "name": "Test User"
  }'
```

Now you need to open your inbox and accept the invitation to sign up.


### Sign in and export idToken
```bash
export ID_TOKEN=$(curl -s -X POST \
  ${INVOKE_URL}/sign-in \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"${EMAIL}"'",
    "password": "Password123!" 
  }' | jq -r '.idToken')                 
```

After signing in export idToken from the response.

```bash
export ID_TOKEN="token"
```

### Create Epic Failures
```bash
curl -X POST \
  ${INVOKE_URL}/create-epic-failure \
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
  ${INVOKE_URL}/create-epic-failure \
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
  ${INVOKE_URL}/get-all-failures \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${ID_TOKEN}"
```

### DELETE Epic Failure
```bash
curl -X DELETE \
  ${INVOKE_URL}/delete-epic-failure \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${ID_TOKEN}" \
  -d '{
    "failureID": "001"
  }'
  '''