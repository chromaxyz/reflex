#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

# Set environment variables
if [ -f .env ]; then
  set -a; source .env; set +a
fi

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

log $GREEN "Deploying on local Anvil instance"

forge script script/Deploy.s.sol \
  --private-key $PRIVATE_KEY \
  --rpc-url http://localhost:8545 \
  --broadcast

log $GREEN "Done"
