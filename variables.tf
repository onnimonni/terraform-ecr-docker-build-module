
variable "ecs_cluster_name"{}
variable "ecs_service_name"{}
variable "dockerfile_folder" {
  type        = string
  description = "This is the folder which contains the Dockerfile"
}

variable "docker_image_tag" {
  type        = string
  description = "This is the tag which will be used for the image that you created"
  default     = "latest"
}

variable "additional_docker_tag"{
  type        = string
  description = "This is an additional tag for images"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region for ECR"
  default     = ""
}

variable "ecr_repository_url" {
  type        = string
  description = "Full url for the ecr repository"
}


variable "additional_docker_flags"{
  type        = string
  description = "This is an additional flags for the docker build"
  default     = ""
}
variable "destroy_task" {
  type        = string
  description = "leave empty to deploy new task by deleting the old one or write no_downtime to use the aws inherit method this is an option because in staging the aws method cannot be used"
  default     = ""
}