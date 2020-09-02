# Terraform Docker build and ECR push module

This is a quite hacky module which contains few bash scripts which build docker images locally and pushes them into AWS ECR using aws cli.

## Requirements

Terraform version needs to be 0.12 or newer.

You need to have following programs installed in your $PATH:

* bash
* md5sum or md5
* aws
* docker
* tar

**Note:** Docker server needs to be running so that we can actually build images

## AWS Credentials
You need to provide AWS credentials as env or profile for aws-cli for this module to work properly

## Example
```hcl
# Create ECR repository
resource "aws_ecr_repository" "test_service" {
  name = "example-service-name"
}

# Build Docker image and push to ECR from folder: ./example-service-directory
module "ecr_docker_build" {
  source = "github.com/onnimonni/terraform-ecr-docker-build-module"

  # Absolute path into the service which needs to be build
  dockerfile_folder = "${path.module}/example-service-directory"

  # Tag for the builded Docker image (Defaults to 'latest')
  docker_image_tag = "development"
  
  # The region which we will log into with aws-cli
  aws_region = "eu-west-1"

  # ECR repository where we can push
  ecr_repository_url = "${aws_ecr_repository.test_service.repository_url}"
}
```

## License
MIT

## Author
[Onni Hakala](https://github.com/onnimonni)
