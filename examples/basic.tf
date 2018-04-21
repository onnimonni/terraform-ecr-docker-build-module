# Create ECR repository
resource "aws_ecr_repository" "test_service" {
  name = "test_service"
}

# Build docker image and push to ecr
# From folder: ./test-service
module "ecr_docker_build" {
  source = "github.com/onnimonni/terraform-ecr-docker-build-module"
  version = "0.1"

  # Absolute path into the service which needs to be build
  dockerfile_folder = "${path.module}/example-service-directory"

  # Tag for the builded Docker image (Defaults to 'latest')
  docker_image_tag = "development"

  # The region which we will log into with aws-cli
  aws_region = "eu-west-1"

  # ECR repository where we can push
  ecr_repository_url = "${aws_ecr_repository.test_service.repository_url}"
}
