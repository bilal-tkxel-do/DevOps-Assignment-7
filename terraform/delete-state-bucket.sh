#!/bin/bash

# Variables
REGION="us-east-1"
S3_BUCKET_NAME="terraform-state-bucket-bilal"

# Deleting all objects in the S3 Bucket
echo "Deleting all objects in the S3 Bucket..."
aws s3 rm s3://"$S3_BUCKET_NAME" --recursive --region "$REGION"

if [ $? -eq 0 ]; then
  echo "All objects deleted from the bucket."
else
  echo "Failed to delete objects from the bucket."
  exit 1
fi

# Deleting the S3 Bucket
echo "Deleting the S3 Bucket..."
aws s3api delete-bucket \
  --bucket "$S3_BUCKET_NAME" \
  --region "$REGION"

if [ $? -eq 0 ]; then
  echo "S3 Bucket deleted successfully."
else
  echo "Failed to delete the S3 Bucket."
  exit 1
fi

echo "All resources have been scheduled for deletion."

