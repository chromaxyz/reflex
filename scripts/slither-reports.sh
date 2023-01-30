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

log $GREEN "Creating Slither reports"

# Remove previous reports
rm -rf reports/slither

# Create directories
mkdir -p \
  reports/slither/call-graph \
  reports/slither/inheritance-graph

# Generate reports
for FILEPATH in src/*.sol; do
  FILENAME_WITH_EXTENSION=${FILEPATH##*"src/"}
  FILENAME=${FILENAME_WITH_EXTENSION%%.*}.md

  echo $FILENAME

  slither $FILEPATH --print inheritance-graph
  mv src/$FILENAME_WITH_EXTENSION.inheritance-graph.dot reports/slither/inheritance-graph/

  slither $FILEPATH --print call-graph
  mv src/$FILENAME_WITH_EXTENSION.*.call-graph.dot reports/slither/call-graph/
done

log $GREEN "Done"
