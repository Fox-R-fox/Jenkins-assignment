#!/bin/bash
# Script to build Docker image and push to Docker Hub

# Define variables
IMAGE_NAME="your_dockerhub_username/app_name"
TAG="latest"

# Log in to Docker Hub
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

# Build the Docker image
docker build -t ${IMAGE_NAME}:${TAG} .

# Push the Docker image to Docker Hub
docker push ${IMAGE_NAME}:${TAG}
