This folder contains the Dockerfile necessary to create the Docker image `landis_ii_v8_calibration_pnet`, which contains:

- **LANDIS-II v8** with all the extensions needed for PnET-Succession calibration (PnET Succession, Output-PnET, and the usual disturbance/output extensions).
- **Jupyter Lab** and all the Python packages required to run the notebooks in this repository.

## How it is built

The heavy LANDIS-II compilation is **no longer done here**. Instead, this image is built on top of the pre-built, multi-stage LANDIS-II runtime image published by the [Tool-Docker-Apptainer](https://github.com/LANDIS-II-Foundation/Tool-Docker-Apptainer) repository:

- `ghcr.io/landis-ii-foundation/landis-ii-v8-uclv2-release:ubuntu-24.04`

That image ships a lean LANDIS-II + all-extensions runtime (≈0.6 GB instead of ≈4 GB) and is updated much more frequently than the old from-scratch Dockerfile. This folder's Dockerfile only adds the Python/Jupyter layer on top of it.

The base image is **pinned by its content digest** (`@sha256:...`) so that builds are fully reproducible. The current pinned digest corresponds to the UCLv2 release image (Universal Cohort Library v2, which fixes a biomass-removal bug present in the older extensions). You can override it with the `BASE_IMAGE` build-arg if you ever need to, e.g. to build against a locally rebuilt base image.

> ⚠ **Note on the Python geo-stack:** the calibration uses a Python GDAL binding. Ubuntu 24.04 ships system GDAL **3.8.4**, and `pip_requirements.txt` pins `GDAL==3.8.4` to match it. If you upgrade the base image or the OS version, you may need to re-check this pin.
>
> ⚠ Ubuntu 24.04 enforces PEP 668 (externally-managed Python), so the Dockerfile uses `pip install --break-system-packages`. This is intentional and safe inside a disposable build image.

## Files

- `Dockerfile` : builds `landis_ii_v8_calibration_pnet` from the pinned base image, adding Python packages, Jupyter Lab, and configuration.
- `buildDockerImage.ps1` / `buildDockerImage.sh` : convenience scripts to build the image (PowerShell and bash).
- `.dockerignore` : keeps the build context lean.
- `files_to_help_compilation/pip_requirements.txt` : the (frozen) list of Python packages for the notebooks.

## Usage

### Build

```powershell
# Windows (PowerShell), from this folder
.\buildDockerImage.ps1

# or directly:
docker build -t landis_ii_v8_calibration_pnet .
```

```bash
# Linux / macOS
./buildDockerImage.sh
```

### Run

```powershell
docker run -it --rm -p 8888:8888 --mount type=bind,src="C:\path\to\PnET-Succession_Calibration_Tool",dst=/calibrationFolder landis_ii_v8_calibration_pnet
```

Jupyter Lab starts automatically on port 8888. The calibration folder is mounted at `/calibrationFolder`. Jupyter Lab is configured to open its file browser **at the filesystem root `/`**, so you can browse every Ubuntu folder (including `/tmp`, where the calibration functions write their simulation files) as well as the bind-mounted `/calibrationFolder` at the top level. It looks for its configuration in `/calibrationFolder` (`.jupyterconfig`), which also restores your saved workspace.

> ⚠️ If you close the terminal where you entered the `docker run` command, the Docker container will close down with it.
