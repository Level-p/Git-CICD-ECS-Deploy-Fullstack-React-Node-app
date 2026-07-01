#!/bin/bash

# set variable for bucket-name
BUCKET_NAME="varsitix-storage-bucket"
AWS_REGION="eu-west-2"
AWS_PROFILE="default"
TERRAFORM_CODE_DIR="./"                   # Directory containing Terraform files
CHECKOV_OUTPUT_FILE="checkov_output.json"  # File to save Checkov scan output
# Run Checkov scan
checkov -d "$TERRAFORM_CODE_DIR" -o cli > "$CHECKOV_OUTPUT_FILE"

# create bucket
aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

# enable versioning
aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" \
  --versioning-configuration Status=Enabled

echo "Creating Vault and Jenkins Server"
terraform init 
terraform validate
terraform fmt
terraform apply -auto-approve
