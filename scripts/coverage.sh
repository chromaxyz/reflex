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

# Check for lcov dependency
if ! [ -x "$(command -v genhtml)" ]; then
  echo 'Error: lcov is not installed. (sudo apt install lcov)' >&2
  exit 1
fi

# Check for http-server dependency
if ! [ -x "$(command -v http-server)" ]; then
  echo 'Error: http-server is not installed. (npm install -g http-server)' >&2
  exit 1
fi

log $GREEN "Creating coverage report"

# Create directory
mkdir -p reports

# Generate coverage report
forge coverage --report lcov

# Remove redundant entries
lcov --remove lcov.info 'test/*' 'script/*' --output-file lcov.info --rc lcov_branch_coverage=1

# Generate HTML report from coverage report
genhtml --branch-coverage -o reports/coverage lcov.info

# Serve HTML report
http-server reports/coverage -o -c-1 -p 0

log $GREEN "Done"
