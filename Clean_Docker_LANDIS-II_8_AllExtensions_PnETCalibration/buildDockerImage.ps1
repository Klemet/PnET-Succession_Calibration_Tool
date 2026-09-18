# ================================================================
# Builds the Docker image landis_ii_v8_calibration_pnet
#
# This image is built ON TOP of the pre-built LANDIS-II v8 UCLv2
# runtime image published by the Tool-Docker-Apptainer project
# (ghcr.io/landis-ii-foundation/landis-ii-v8-uclv2-release),
# pinned by content digest. The heavy LANDIS-II compilation is
# already done in that base image, so this build only adds the
# Python/Jupyter layer and is comparatively quick.
#
# Usage (from this folder):
#   .\buildDockerImage.ps1
#
# Optional: point to a different (e.g. locally rebuilt) base image:
#   .\buildDockerImage.ps1 -BaseImage landis-ii-v8-uclv2-release:ubuntu-24.04
# ================================================================

param(
    [string]$BaseImage = ""
)

# The folder where this script lives.
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $scriptDir

if ($BaseImage -eq "") {
    # Use the pinned digest baked into the Dockerfile (default, reproducible).
    docker build -t landis_ii_v8_calibration_pnet .
} else {
    docker build --build-arg "BASE_IMAGE=$BaseImage" -t landis_ii_v8_calibration_pnet .
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Image 'landis_ii_v8_calibration_pnet' built successfully." -ForegroundColor Green

pause