#!/bin/bash

# Fail fast
set -e

# List of arguments
build_folder=$1
exclude_tar_dirs='--exclude=".git" --exclude=".terraform"'

which tar > /dev/null || { echo 'ERROR: tar is not installed' ; exit 1; }

# Linux has command md5sum and OSX has command md5
if command -v md5sum >/dev/null 2>&1; then
  MD5_PROGRAM=md5sum
elif command -v md5 >/dev/null 2>&1; then
  MD5_PROGRAM=md5
else
  echo "ERROR: md5sum is not installed"
  exit 255
fi

## Check folder exists
[ -d "$build_folder" ] || { echo "ERROR: Directory $build_folder not found" ; exit 1; }

### Archive using git archive
archive_cmd="tar -c $exclude_tar_dirs -f - $build_folder"

# Take md5 from each object inside the program and then take a md5 of that output
md5_output=$(eval $archive_cmd | $MD5_PROGRAM )

# Output result as JSON back to terraform
echo "{ \"md5\": \"$md5_output\" }"
