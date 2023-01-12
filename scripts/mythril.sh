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

log $GREEN "Running Mythril script"

mkdir -p flattened

forge flatten src/internals/Proxy.sol --output flattened/Proxy.flat.sol
forge flatten test/mocks/MockBaseDispatcher.sol --output flattened/MockBaseDispatcher.flat.sol
forge flatten test/implementations/ImplementationDispatcher.sol --output flattened/ImplementationDispatcher.flat.sol

myth -v 4 analyze flattened/Proxy.flat.sol
myth -v 4 analyze flattened/MockBaseDispatcher.flat.sol
myth -v 4 analyze flattened/ImplementationDispatcher.flat.sol

rm -rf flattened

log $GREEN "Done"
