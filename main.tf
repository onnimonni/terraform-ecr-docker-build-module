locals {
  docker_image_tag = var.use_md5_as_tag ? data.external.build_folder.result.md5 : var.docker_image_tag
}

# Checks if build folder has changed
data "external" "build_folder" {
  program = ["${path.module}/bin/folder_contents.sh", var.dockerfile_folder]
}

# Builds test-service and pushes it into aws_ecr_repository
resource "null_resource" "build_and_push" {
  triggers = {
    build_folder_content_md5 = data.external.build_folder.result.md5
  }

  # See build.sh for more details
  # See build.sh for more details
  provisioner "local-exec" {
    command = "${path.module}/bin/build.sh ${var.dockerfile_folder} ${var.ecr_repository_url}:${local.docker_image_tag} ${var.aws_region}"
  }
}

