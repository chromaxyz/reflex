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

# Check for Mythril dependency
if ! [ -x "$(command -v myth)" ]; then
  echo 'Error: myth is not installed.' >&2
  exit 1
fi

log $GREEN "Creating Mythril report"

# Generate a fresh build
forge build

# Flatten select files
forge flatten src/BaseProxy.sol --output flattened/BaseProxy.sol
forge flatten test/mocks/MockBaseDispatcher.sol --output flattened/MockBaseDispatcher.sol
forge flatten test/implementations/ImplementationDispatcher.sol --output flattened/ImplementationDispatcher.sol

# Analyze flattened files
myth -v 4 analyze flattened/BaseProxy.sol
myth -v 4 analyze flattened/MockBaseDispatcher.sol
myth -v 4 analyze flattened/ImplementationDispatcher.sol

log $GREEN "Done"
