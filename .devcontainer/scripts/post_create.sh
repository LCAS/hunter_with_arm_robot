#!/bin/bash

set -e -x

WORKSPACE_DIR=/workspace

# Remove directories if they exist
rm -rf ${WORKSPACE_DIR}/install
rm -rf ${WORKSPACE_DIR}/build
rm -rf ${WORKSPACE_DIR}/log

bash ${WORKSPACE_DIR}/src/.devcontainer/scripts/build_workspace.sh
bash ${WORKSPACE_DIR}/src/.devcontainer/scripts/startup.sh
bash ${WORKSPACE_DIR}/src/.devcontainer/scripts/vnc.sh

# Create directories
mkdir -p ${WORKSPACE_DIR}/install
mkdir -p ${WORKSPACE_DIR}/build
mkdir -p ${WORKSPACE_DIR}/log

# Set ownership to ros user and group
chown -R ros:ros ${WORKSPACE_DIR}/install
chown -R ros:ros ${WORKSPACE_DIR}/build
chown -R ros:ros ${WORKSPACE_DIR}/log

cd ${WORKSPACE_DIR} && colcon build
