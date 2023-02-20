#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Change directory to project root
SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

# Utilities
GREEN="\033[00;32m"

function log () {
  echo -e "$1"
  echo "################################################################################"
  echo "#### $2 "
  echo "################################################################################"
  echo -e "\033[0m"
}

log $GREEN "Creating storage overview from contracts"

# Variables
CONTRACTS="ReflexBase ReflexDispatcher ReflexInstaller ReflexModule ReflexEndpoint ReflexBatch"

# Remove previous reports
rm -rf reports/abi

# Create directories
mkdir -p reports/abi

# Generate a fresh build
forge build

# Generate ABIs
for CONTRACT in ${CONTRACTS[@]}
do
  forge inspect "$CONTRACT" abi > reports/abi/$CONTRACT.json
done

log $GREEN "Done"
