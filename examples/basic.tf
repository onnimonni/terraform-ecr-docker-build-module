# Create ECR repository
resource “aws_ecr_repository” “test_service” {
  name = “test_service”
}

# Equivalent of aws ecr get-login
data “aws_ecr_authorization_token” “ecr_token” {}

# Multiple docker push commands can be run against a single token
resource “null_resource” “renew_ecr_token” {
  triggers = {
    token_expired = data.aws_ecr_authorization_token.ecr_token.expires_at
  }

  provisioner “local-exec” {
    command = “echo ${data.aws_ecr_authorization_token.ecr_token.password} | docker login —username ${data.aws_ecr_authorization_token.ecr_token.user_name} —password-stdin ${data.aws_ecr_authorization_token.ecr_token.proxy_endpoint}”
  }
}

# Build docker image and push to ecr
# From folder: ./test-service
module “ecr_docker_build” {
  source = “github.com/onnimonni/terraform-ecr-docker-build-module”
  version = “0.1”

  # Absolute path into the service which needs to be build
  dockerfile_folder = “${path.module}/example-service-directory”

  # Tag for the builded Docker image (Defaults to ‘latest’)
  docker_image_tag = “development”

  # The region which we will log into with aws-cli
  aws_region = “eu-west-1”

  # ECR repository where we can push
  ecr_repository_url = “${aws_ecr_repository.test_service.repository_url}”
  
  # Acquire ecr auth token only once
  depends_on = [null_resource.renew_ecr_token]
}
