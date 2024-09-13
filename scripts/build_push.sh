#!/bin/bash

# Set variables
REPO_URL="public.ecr.aws/k0n5u3j8/test"
IMAGE_TAG="latest"
AWS_REGION="ap-south-1"
SECRET_ARN="arn:aws:secretsmanager:ap-south-1:339712721384:secret:dockerhublogin-4vcmMW"

# Ensure jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found. Please install jq."
    exit 1
fi

# Get Docker credentials from AWS Secrets Manager
DOCKER_USERNAME=$(aws secretsmanager get-secret-value --secret-id $SECRET_ARN --query 'SecretString' --output text | jq -r .username)
DOCKER_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $SECRET_ARN --query 'SecretString' --output text | jq -r .password)

if [[ -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" ]]; then
  echo "Failed to retrieve Docker credentials from AWS Secrets Manager."
  exit 1
fi

# Login to AWS ECR (using public ECR login for public repositories)
aws ecr-public get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL

# Check if login was successful
if [[ $? -ne 0 ]]; then
  echo "Failed to login to ECR."
  exit 1
fi

# Build the Docker image (specifying the correct path for Dockerfile)
docker build -t $REPO_URL:$IMAGE_TAG -f app/Dockerfile app

# Check if the build was successful
if [[ $? -ne 0 ]]; then
  echo "Docker build failed."
  exit 1
fi

# Push the image to ECR
docker push $REPO_URL:$IMAGE_TAG

# Check if the push was successful
if [[ $? -ne 0 ]]; then
  echo "Docker push failed."
  exit 1
fi

echo "Docker image built and pushed successfully."
