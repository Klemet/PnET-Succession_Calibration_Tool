# ================================================================
# Docker image : landis_ii_v8_calibration_pnet
#
# This image provides the LANDIS-II v8 model (core + all needed
# extensions) plus Jupyter Lab and the Python packages required to
# run the PnET-Succession calibration notebooks.
#
# The heavy LANDIS-II compilation is NO LONGER done here. Instead we
# build on top of the pre-built, multi-stage image published by the
# Tool-Docker-Apptainer project (ghcr.io/landis-ii-foundation/
# landis-ii-v8-uclv2-release). That image ships a lean LANDIS-II +
# all extensions runtime (~0.6 GB) that is updated much more
# frequently than the old from-scratch Dockerfile ever was.
#
# The base image is pinned by its CONTENT DIGEST so that builds are
# fully reproducible regardless of future releases. To intentionally
# switch to a different (locally built or newer) base, override the
# BASE_IMAGE build-arg, e.g.:
#   docker build --build-arg BASE_IMAGE=landis-ii-v8-uclv2-release:ubuntu-24.04 .
# ================================================================

# Latest image with unbuntu 24.04 at the time of re-writing this dockerfile (19 August 2026)
# The image contains most of the UCLv2 fixed extensions, included PnET-Succession 6.1 (although it's still displayed as v6.0.3; see https://github.com/LANDIS-II-Foundation/Extension-PnET-Succession/issues/26).
# Missing for now : a succession library fix for simulations using the parallel parameter. See https://github.com/LANDIS-II-Foundation/Library-Succession/issues/25 and https://github.com/LANDIS-II-Foundation/Library-Succession/pull/26). Should not cause problems for the calibration of PnET-Succession, as the bugs from the original issue tend to arise on large landscapes. But shoudl be updated if possible.
ARG BASE_IMAGE=ghcr.io/landis-ii-foundation/landis-ii-v8-uclv2-release:ubuntu-24.04@sha256:c1e895e629c3a87ff9b0fc1d18de5efb1c19f073f53e24da94246b5fc4150616

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

# ================================================================
# SYSTEM PACKAGES FOR THE PYTHON/JUPYTER LAYER
# ================================================================
# The base image already provides: python3, python-is-python3,
# dotnet-runtime-8.0, libjpeg62, libpng16-16t64, libxml2, libexpat1,
# and LANDIS-II itself (with LANDIS_CONSOLE / LANDIS_EXT_TOOL set).
#
# Here we add what the calibration notebooks need on top:
#   - python3-pip          : pip is NOT installed in the runtime image
#   - gdal-bin/libgdal-dev : the Python geo stack (GDAL bindings,
#                            rasterio, etc.) needs the system GDAL 3.8.4
#   - build-essential, python3-dev, libffi-dev, libgeos-dev, libproj-dev,
#     gfortran, cmake      : so GDAL and the geo wheels can compile/resolve
#   - git, wget, curl, unzip, nano, vim, axel, dos2unix : general tooling
#     (as in the original Dockerfile)
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        python3-pip \
        build-essential \
        python3-dev \
        libffi-dev \
        gdal-bin \
        libgdal-dev \
        libgeos-dev \
        libproj-dev \
        git \
        wget \
        curl \
        unzip \
        nano \
        vim \
        axel \
        dos2unix \
        ssl-cert \
        ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ================================================================
# COMPATIBILITY ENVIRONMENT VARIABLES
# ================================================================
# The base image exports LANDIS_CONSOLE and LANDIS_EXT_TOOL (pointing
# at /opt/landis-ii/...). The calibration notebooks only use
# LANDIS_CONSOLE, which is already correct. We re-export the legacy
# variable names from the old image (LANDIS_FOLDER and
# LANDIS_EXTENSIONS_TOOL) so that any external script relying on the
# old names keeps working.
ENV LANDIS_FOLDER="/opt/landis-ii/Core-Model-v8-LINUX/"
ENV LANDIS_EXTENSIONS_TOOL="$LANDIS_EXT_TOOL"

# ================================================================
# PYTHON PACKAGES FOR THE CALIBRATION NOTEBOOKS
# ================================================================
# NOTE: Ubuntu 24.04 enforces PEP 668 (externally-managed Python), so
# pip refuses a system-wide install unless we pass --break-system-packages.
# This is safe here because this image is purpose-built and disposable.

COPY ./files_to_help_compilation/pip_requirements.txt /tmp

RUN pip install --break-system-packages \
        --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org \
        -r /tmp/pip_requirements.txt

# ================================================================
# JUPYTER LAB + EXTENSIONS
# ================================================================

# Jupyter lab (matching the original image's final version)
RUN pip install --break-system-packages jupyterlab==4.5.3

# Node.js is required to build some JupyterLab extensions (e.g. MyST)
RUN apt-get update && apt-get install -y curl \
    && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Jupyter book (for rebuilding the static documentation website)
RUN pip install --break-system-packages --pre "jupyter-book==2.*"

# Add-on "Variable explorer" for Jupyter lab
RUN pip install --break-system-packages lckr-jupyterlab-variableinspector

# Add-on to make markdown code look better
RUN pip install --break-system-packages jupyterlab_myst

# zenodo-get : fast download from Zenodo data.
# See https://github.com/dvolgyes/zenodo_get
RUN pip install --break-system-packages zenodo-get

# ================================================================
# JUPYTER CONFIGURATION
# ================================================================

# Enable JupyterLab
ENV JUPYTER_ENABLE_LAB=yes

# Save Jupyter lab config in the folder we'll use, /calibrationFolder
ENV JUPYTER_CONFIG_DIR=/calibrationFolder/.jupyterconfig
ENV JUPYTERLAB_SETTINGS_DIR=/calibrationFolder/.jupyterconfig/lab/user-settings

# JupyterLab opens its file browser in the current working directory by
# default. The base image sets WORKDIR to /opt/landis-ii, which hid the
# rest of the filesystem. To let users browse every Ubuntu folder (e.g.
# /tmp, where the calibration functions write their simulation files, and
# the bind-mounted /calibrationFolder), we root JupyterLab at the filesystem
# root "/" -- the /calibrationFolder mount is then visible at the top level,
# and the saved workspace is still restored via JUPYTER_CONFIG_DIR.
WORKDIR /

# Expose port 8888 for JupyterLab
EXPOSE 8888

# Make JupyterLab start with the container, rooted at the whole filesystem
# so that all Ubuntu folders (including /tmp and /calibrationFolder) are
# browsable, as with the original image.
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--notebook-dir=/"]
