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

log $GREEN "Generating and serving docs"

forge doc --build
forge doc --serve

log $GREEN "Done"
