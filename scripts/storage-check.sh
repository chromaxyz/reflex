#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Change directory to project root
SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

# Utilities
RED="\033[00;31m"
GREEN="\033[00;32m"

function log () {
  echo -e $1
  echo "################################################################################"
  echo "#### $2 "
  echo "################################################################################"
  echo -e "\033[0m"
}

function notify () {
  echo -e $1
  echo "$2 "
  echo -e "\033[0m"
}

log $GREEN "Verifying storage overview from contracts"

# Variables
CONTRACTS="ReflexBase ReflexConstants ReflexDispatcher ReflexInstaller ReflexModule ReflexEndpoint ReflexState ReflexBatch MockImplementationDispatcher"
FILENAME=reports/STORAGE_LAYOUT.md
TEMP_FILENAME=reports/STORAGE_LAYOUT.temp.md

# Remove previous temporary storage layout
rm -f "$TEMP_FILENAME"

# Generate a fresh build
forge build

# Generate new temporary storage layout for diff
for CONTRACT in ${CONTRACTS[@]}
do
  echo "Verifying storage layout for $CONTRACT..."

  echo -e "\n**$CONTRACT**\n" >> "$TEMP_FILENAME"

  forge inspect --pretty "$CONTRACT" storage-layout >> "$TEMP_FILENAME"
done

# Run prettier so diff works properly
npx prettier --write "$TEMP_FILENAME"

if ! cmp -s "$FILENAME" "$TEMP_FILENAME"; then
  notify $RED "Failed!"

  echo "The following lines are different:"
  diff -a --suppress-common-lines "$FILENAME" "$TEMP_FILENAME" || true
  rm -f "$TEMP_FILENAME"

  log $GREEN "Done"
  exit 1
else
  notify $GREEN "Success!"

  rm -f "$TEMP_FILENAME"

  log $GREEN "Done"
  exit 0
fi
