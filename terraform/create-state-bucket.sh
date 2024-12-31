#!/bin/bash

# Variables
REGION="us-east-1" # Specify the desired region
S3_BUCKET_NAME="terraform-state-bucket-bilal"

# Create the S3 Bucket
echo "Creating S3 Bucket..."
aws s3api create-bucket \
  --bucket "$S3_BUCKET_NAME" \
  --region "$REGION"

echo "S3 Bucket for Terraform state created successfully!"
echo "Bucket Name: $S3_BUCKET_NAME"
echo "Region: $REGION"

