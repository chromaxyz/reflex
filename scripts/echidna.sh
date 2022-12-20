#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Change directory to project root
SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

# Utilities
GREEN='\033[00;32m'

function log () {
    echo -e "$1"
    echo "################################################################################"
    echo "#### $2 "
    echo "################################################################################"
    echo -e "\033[0m"
}

# Check for Echidna dependency
if ! [ -x "$(command -v echidna-test)" ]; then
  echo 'Error: echidna-test is not installed.' >&2
  exit 1
fi

log $GREEN "Running Echidna script"

mkdir -p reports/echidna

# Test modes: 'property', 'assertion', 'dapptest', 'optimization', 'overflow' or 'exploration

echidna-test echidna/*.sol --test-mode assertion --test-limit 50000 --corpus-dir reports/echidna

log $GREEN "Done"
