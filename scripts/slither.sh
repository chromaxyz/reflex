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

# Check for Slither dependency
if ! [ -x "$(command -v slither)" ]; then
  echo 'Error: slither is not installed.' >&2
  exit 1
fi

log $GREEN "Running Slither script"

mkdir -p reports

slither . \
  --filter-path "node_modules|lib|test" \
  --exclude "solc-version" \
  --markdown-root "../" \
  --checklist \
  --solc-remaps '$(cat remappings.txt)' \
  > reports/slither.md

log $GREEN "Done"
