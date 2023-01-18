#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Set environment variables
set -a; source .env; set +a

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

log $GREEN "Deploying to local using IntegrationTest.s.sol"

forge script ./script/IntegrationTest.s.sol \
  --rpc-url $LOCAL_RPC_URL \
  --private-key $LOCAL_PRIVATE_KEY \
  --broadcast \
  --slow

log $GREEN "Done"
