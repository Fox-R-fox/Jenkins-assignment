#!/bin/bash

# Set variables
REPO_URL="public.ecr.aws/k0n5u3j8/test1"  # Ensure this matches your public ECR repo
IMAGE_NAME="test1"
IMAGE_TAG="latest"
AWS_REGION="us-east-1"

# Login to AWS ECR (for public repositories)
aws ecr-public get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $REPO_URL

if [[ $? -ne 0 ]]; then
  echo "Failed to login to ECR."
  exit 1
fi

# Build the Docker image (using the Dockerfile from the app directory)
docker build -t $IMAGE_NAME -f app/Dockerfile app

if [[ $? -ne 0 ]]; then
  echo "Docker build failed."
  exit 1
fi

# Tag the image for ECR (no additional directory structure needed)
docker tag $IMAGE_NAME:$IMAGE_TAG $REPO_URL:$IMAGE_TAG

if [[ $? -ne 0 ]]; then
  echo "Docker tag failed."
  exit 1
fi

# Push the image to ECR
docker push $REPO_URL:$IMAGE_TAG

if [[ $? -ne 0 ]]; then
  echo "Docker push failed."
  exit 1
fi

echo "Docker image built, tagged, and pushed successfully."
