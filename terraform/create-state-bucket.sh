#!/bin/bash

# Variables
REGION="us-east-1" # Specify the desired region
S3_BUCKET_NAME="terraform-state-bucket-bilal"

# Create the S3 Bucket
echo "Creating S3 Bucket..."
aws s3api create-bucket \
  --bucket "$S3_BUCKET_NAME" \
  --region "$REGION"

# Enable versioning on the S3 Bucket
echo "Enabling versioning on S3 Bucket..."
aws s3api put-bucket-versioning \
  --bucket "$S3_BUCKET_NAME" \
  --versioning-configuration Status=Enabled

# Apply default encryption to the S3 Bucket
echo "Applying default encryption to S3 Bucket..."
aws s3api put-bucket-encryption \
  --bucket "$S3_BUCKET_NAME" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

echo "S3 Bucket for Terraform state created successfully!"
echo "Bucket Name: $S3_BUCKET_NAME"
echo "Region: $REGION"

