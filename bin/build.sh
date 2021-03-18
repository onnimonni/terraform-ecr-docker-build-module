#!/bin/bash

# Fail fast
set -e

# This is the order of arguments
build_folder=$1
aws_ecr_repository_url_with_tag=$2
# kept for backwards compatibility
aws_region=$3
dockerfile_name=$4

# Allow overriding the aws region from system
if [ "$aws_region" != "" ]; then
  aws_extra_flags="--region $aws_region"
else
  aws_extra_flags=""
fi

# Check that aws is installed
which aws > /dev/null || { echo 'ERROR: aws-cli is not installed' ; exit 1; }

# Check that docker is installed and running
which docker > /dev/null && docker ps > /dev/null || { echo 'ERROR: docker is not running' ; exit 1; }

# Connect into aws
(aws ecr get-login-password $aws_extra_flags | docker login --username AWS --password-stdin $aws_ecr_repository_url_with_tag) || echo 'Credentials already in keychan'

# Some Useful Debug
echo "Building $aws_ecr_repository_url_with_tag from $build_folder/$dockerfile_name"

# Build image
docker build -t $aws_ecr_repository_url_with_tag $build_folder --file $build_folder$dockerfile_name

# Push image
docker push $aws_ecr_repository_url_with_tag