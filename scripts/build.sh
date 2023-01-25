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

# Variables
while getopts p: flag
do
  case "${flag}" in
    p) PROFILE=${OPTARG};;
  esac
done

# Set Foundry profile
export FOUNDRY_PROFILE=$PROFILE

log $GREEN "Building with profile: $PROFILE"

forge build --sizes

log $GREEN "Done"
