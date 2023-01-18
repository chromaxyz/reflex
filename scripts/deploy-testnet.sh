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

log $GREEN "Deploying to testnet using Deploy.s.sol"

forge script ./script/Deploy.s.sol \
  --rpc-url $ETH_RPC_URL \
  --private-key $ETH_PRIVATE_KEY \
  # --etherscan-api-key $ETHERSCAN_API_KEY \
  # --verify \
  # --broadcast

log $GREEN "Done"
