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
while getopts p:s: flag
do
  case "${flag}" in
    p) PROFILE=${OPTARG};;
    s) SCOPE=${OPTARG};;
  esac
done

# Set Foundry profile
export FOUNDRY_PROFILE=$PROFILE

log $GREEN "Creating snapshot with profile: $PROFILE"

# Back up old snapshot
cp .gas-snapshot-$PROFILE .gas-snapshot-$PROFILE-old

# Create snapshot
forge snapshot \
    --match-test $SCOPE \
    --snap .gas-snapshot-$PROFILE

# Generate diff
diff .gas-snapshot-$PROFILE .gas-snapshot-$PROFILE-old > .gas-snapshot-$PROFILE-diff

log $GREEN "Done"
