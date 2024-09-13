git push -u origin main#!/bin/bash

REPO_URL ="339712721384.dkr.ecr.ap-south-1.amazonaws.com/test"
IMAGE_TAG="latest"
AWS_REGION="ap-south-1"
SECRET_ARN='arn:aws:secretsmanager:ap-south-1:339712721384:secret:dockerhublogin-4vcmMW'

DOCKER_USERNAME=$(aws secretmanager get-secret-value --secret-id &SECRET_ARN --query 'SecretString' --output text | jq -r .username)
DOCKER_PASSWORD=$(aws secretmanager get-secret-value --secret-id &SECRET_ARN --query 'SecretString' --output text | jq -r .password)

aws ecr-public get-login-password --region $AWS_REGION | docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWORD $REPO_URL

docker build -t $REPO_URL:$IMAGE_TAG

docker push $REPO_URL:$IMAGE_TAG