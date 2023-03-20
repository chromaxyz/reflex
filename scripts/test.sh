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

# Variables
while getopts p:s:c: flag
do
  case "${flag}" in
    p) PROFILE=${OPTARG};;
    s) SCOPE=${OPTARG};;
    c) CONTRACT=${OPTARG};;
  esac
done

# Set Foundry profile
export FOUNDRY_PROFILE=$PROFILE

log $GREEN "Running tests with profile: $PROFILE"

if [[ "$PROFILE" = "default" || "$PROFILE" = "intense" || "$PROFILE" = "min-solc" || "$PROFILE" = "via-ir" || "$PROFILE" = "min-solc-via-ir" ]]; then
  forge test \
    --match-test $SCOPE
fi

if [[ "$PROFILE" = "unbounded" || "$PROFILE" = "bounded" ]]; then
  forge test \
    --match-contract $CONTRACT
fi

log $GREEN "Done"
