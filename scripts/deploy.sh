#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Set environment variables
set -a;
source .env;
set +a

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

log $GREEN "Deploying using Deploy.s.sol"

# Check for arguments passed
if [ $# -eq 0 ]
  then
    echo "Please supply contract name."
fi

forge script ./script/Deploy.s.sol --broadcast --rpc-url $ETH_RPC_URL --private-key $ETH_PRIVATE_KEY

log $GREEN "Done"
