#!/bin/bash

# Get the directory where the script is located
calibrationPath="$(cd "$(dirname "$0")" && pwd)"

# Ensure the path exists
if [ ! -d "$calibrationPath" ]; then
    echo "Calibration folder not found at $calibrationPath" >&2
    exit 1
fi

# Run the Docker container with the resolved absolute path
docker run -it --rm -p 8888:8888 -p 3000:3000 --mount type=bind,src="$calibrationPath",dst=/calibrationFolder landis_ii_v8_calibration_pnet

# Equivalent of 'pause' — wait for the user to press Enter
read -rp "Press Enter to continue..."
