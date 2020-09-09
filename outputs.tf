output "ecr_image_url" {
  value       = "${var.ecr_repository_url}:${local.docker_image_tag}"
  description = "Full URL to image in ecr with tag"
}
