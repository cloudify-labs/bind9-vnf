#! /bin/bash

DEPLOYMENT_ID=$(ctx deployment id)

CONFIG_DIR="/etc/healing"
SCRIPT_BASE="/root"


ctx logger info "Retrieved deployment_id: $DEPLOYMENT_ID"


SCRIPT_DIR="${SCRIPT_BASE}/${DEPLOYMENT_ID}"
ctx logger info "Script dir is: $SCRIPT_DIR"
ctx logger info "Used python : $(which python)"
ctx logger info "Creating Directories Config : ${CONFIG_DIR} , scripts ${SCRIPT_DIR}"
NODES_TO_MONITOR_PATH=${SCRIPT_DIR}/nodes_to_monitor
ctx instance runtime_properties nodes_to_monitor_path ${NODES_TO_MONITOR_PATH}

mkdir -p ${CONFIG_DIR}
mkdir -p ${SCRIPT_DIR}
touch ${NODES_TO_MONITOR_PATH}


pipPath=$(which pip)
ctx logger info "deployment_id = ${DEPLOYMENT_ID}, current pip is ${pipPath}"
ctx logger info "Running ${pipPath} install influxdb  ... "
${pipPath} install influxdb
statusCode=$?
if [ $statusCode -gt 0 ]; then 
  ctx logger info "Aborting due to a failure with exit code ${statusCode} in ${pipPath} install influxdb"
  exit ${statusCode}
fi

ctx logger info "Downloading scripts/healing/healing.py and Copying it to ${SCRIPT_DIR}"

cp $(ctx download-resource scripts/healing/healing.py) ${SCRIPT_DIR}
status_code=$?
ctx logger info "ctx download-resource status code is ${status_code}"
