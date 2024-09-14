#!/bin/bash
# Script to build Docker image and push to Docker Hub

# Define variables
IMAGE_NAME="foxe03/app"
TAG="latest"

# Log in to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Build the Docker image, specifying the path to the Dockerfile
docker build -t ${IMAGE_NAME}:${TAG} -f ./app/Dockerfile .

# Push the Docker image to Docker Hub
docker push ${IMAGE_NAME}:${TAG}
