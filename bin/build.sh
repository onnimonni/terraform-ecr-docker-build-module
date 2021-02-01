#!/bin/bash

# Fail fast
set -e

function get_task_arns_to_remove {
  local OLD_TASK_IDS=$(aws ecs list-tasks --cluster $ecs_cluster_name \
   --service-name $ecs_service_name --region $aws_region --desired-status RUNNING \  # this command returns a json list so we need to break it down
  | grep -E "task/" \  # looking for the line with the word task
  | sed -E "s/.*task\/(.*)\"/\1/")  # looking for all chars after "task"
  array=($(echo "$OLD_TASK_IDS" | tr ',\n' '\n'))  # making an arr by /n,
}
# This is the order of arguments
build_folder=$1
aws_ecr_repository_url=$2
tag=$3
# kept for backwards compatibility

ecs_cluster_name=$4
ecs_service_name=$5
additional_docker_tag=$6
aws_region=$7
additional_docker_flags=$8
destroy_task=$9


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
aws ecr get-login-password $aws_extra_flags | docker login --username AWS --password-stdin $aws_ecr_repository_url:$tag
# Some Useful Debug
echo "Building $aws_ecr_repository_url:$tag from $build_folder/Dockerfile"

# Build image
if [ "$additional_docker_tag" != "" ]; then
  docker build -t $aws_ecr_repository_url:$tag -t $aws_ecr_repository_url:$additional_docker_tag $build_folder $additional_docker_flags
else
  docker build -t $aws_ecr_repository_url:$tag $build_folder $additional_docker_flags
fi
# Push image
version=`echo "$(printf $(docker version --format {{.Server.Version}})'\n20.10.0'| sort -V)" | head -1`
# This commad is to see if the docker version is smaller or bigger than 20.10.0
if [ "$version" == "20.10.0" ]; then
  docker push -a $aws_ecr_repository_url
else
  docker push $aws_ecr_repository_url
fi

# Update the ecs service
if [ "$destroy_task" != "no_downtime" ]; then
  get_task_arns_to_remove
  for element in "${array[@]}"
  do
      aws ecs stop-task --cluster $ecs_cluster_name --task ${element}
  done
else
  aws ecs update-service --cluster $ecs_cluster_name  --service $ecs_service_name --force-new-deployment
fi
