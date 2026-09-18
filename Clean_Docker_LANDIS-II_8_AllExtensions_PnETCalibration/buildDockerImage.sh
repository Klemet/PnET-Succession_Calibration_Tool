#!/bin/bash

# Build the Docker image with the specified tag.
# The image is built on top of the pre-built LANDIS-II v8 UCLv2 runtime
# image (ghcr.io/landis-ii-foundation/landis-ii-v8-uclv2-release) pinned
# by digest, so this only adds the Python/Jupyter layer.
#
# Optional: override the base image with a locally rebuilt tag, e.g.:
#   ./buildDockerImage.sh landis-ii-v8-uclv2-release:ubuntu-24.04

BASE_IMAGE="${1:-}"

if [ -z "$BASE_IMAGE" ]; then
  docker build -t landis_ii_v8_calibration_pnet .
else
  docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t landis_ii_v8_calibration_pnet .
fi