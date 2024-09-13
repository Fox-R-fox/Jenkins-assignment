#!/bin/bash

# Set variables
REPO_URL="public.ecr.aws/k0n5u3j8/test"
IMAGE_TAG="latest"
AWS_REGION="ap-south-1"
SECRET_ARN="arn:aws:secretsmanager:ap-south-1:339712721384:secret:dockerhublogin-4vcmMW"

# Get Docker credentials from AWS Secrets Manager
DOCKER_USERNAME=$(aws secretsmanager get-secret-value --secret-id $SECRET_ARN --query 'SecretString' --output text | jq -r .username)
DOCKER_PASSWORD=$(aws secretsmanager get-secret-value --secret-id $SECRET_ARN --query 'SecretString' --output text | jq -r .password)

# Login to AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL

# Build the Docker image
docker build -t $REPO_URL:$IMAGE_TAG .

# Push the image to ECR
docker push $REPO_URL:$IMAGE_TAG
