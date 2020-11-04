variable "dockerfile_folder" {
  type        = string
  description = "This is the folder which contains the Dockerfile"
}

variable "docker_image_tag" {
  type        = string
  description = "This is the tag which will be used for the image that you created"
  default     = "latest"
}

variable "aws_region" {
  type        = string
  description = "AWS region for ECR"
  default     = ""
}

variable "aws_profile" {
  type        = string
  description = "AWS profile used in AWS CLI"
  default     = "default"
}

variable "ecr_repository_url" {
  type        = string
  description = "Full url for the ecr repository"
}

