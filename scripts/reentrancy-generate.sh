#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Change directory to project root
SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

# Utilities
GREEN="\033[00;32m"

function log () {
  echo -e $1
  echo "################################################################################"
  echo "#### $2 "
  echo "################################################################################"
  echo -e "\033[0m"
}

# Check for jq dependency
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

log $GREEN "Creating reentrancy modifier overview from contracts"

# Variables
CONTRACTS="ReflexBase ReflexConstants ReflexDispatcher ReflexInstaller ReflexModule ReflexEndpoint ReflexState ReflexBatch MockImplementationDispatcher"
FILENAME=reports/REENTRANCY_LAYOUT.md

# Remove previous reentracy layout
rm -f "$FILENAME"

# Generate a fresh build
forge build

# Generate new reentracy layout
for CONTRACT in ${CONTRACTS[@]}
do
  echo "Generating reentrancy layout for $CONTRACT..."

  echo -e "\n**$CONTRACT**\n\n\`\`\`json" >> "$FILENAME"

  cat out/$CONTRACT.sol/$CONTRACT.json | jq '
    .ast.nodes |
    map(.nodes) |
    flatten |
    .[] |
    select(.kind=="function") |
    select(.stateMutability!="view") |
    select(.stateMutability!="pure") |
    select(.visibility=="public") |
    { name: .name, modifiers: .modifiers }' >> "$FILENAME"

  echo -e "\`\`\`" >> "$FILENAME"
done

# Run prettier so diff works properly
npx prettier --write "$FILENAME"

log $GREEN "Done"
