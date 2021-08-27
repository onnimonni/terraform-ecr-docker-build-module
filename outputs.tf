output "ecr_image_url" {
  value       = "${var.ecr_repository_url}:${var.docker_image_tag}"
  description = "Full URL to image in ecr with tag"
}

output "build_id" {
  value = null_resource.build_and_push.id
}