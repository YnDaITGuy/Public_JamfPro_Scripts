#/bin/sh

## Model Identifer

modelID=$(system_profiler SPHardwareDataType | awk '/Name/ {print $3}')
echo "Model ID: $modelID"
