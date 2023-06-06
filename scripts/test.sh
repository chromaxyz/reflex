#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

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

# Default settings
VERBOSITY_LEVEL=2

# Variables
while getopts p:s:c:v: flag
do
  case "${flag}" in
    p) PROFILE=${OPTARG};;
    s) SCOPE=${OPTARG};;
    c) CONTRACT=${OPTARG};;
    v) VERBOSITY_LEVEL=${OPTARG};;
  esac
done

# Set default verbosity
VERBOSITY=-$(seq $VERBOSITY_LEVEL | awk '{printf "v"}')

# Set Foundry profile
export FOUNDRY_PROFILE=$PROFILE

log $GREEN "Running tests with profile: $PROFILE"

if [[ "$PROFILE" = "default" || "$PROFILE" = "intense" || "$PROFILE" = "min-solc" || "$PROFILE" = "via-ir" || "$PROFILE" = "min-solc-via-ir" ]]; then
  forge test \
    --match-test $SCOPE \
    --verbosity $VERBOSITY
fi

log $GREEN "Done"
