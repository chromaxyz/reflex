#!/usr/bin/env bash

# Exit if anything fails
set -euo pipefail

# Enter glob mode
shopt -s extglob

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

log $GREEN "Checking reentrancy modifiers on external methods"

# Variables
CONTRACTS="BaseDispatcher BaseInstaller"
FILENAME=docs/REENTRANCY.md

# Remove previous storage layout
rm -f $FILENAME

# Generate a fresh build
forge build

# Generate new temporary storage layout for diff
for CONTRACT in ${CONTRACTS[@]}
do
    echo -e "\n**$CONTRACT**\n\n\`\`\`json" >> "$FILENAME"

    cat out/$CONTRACT.sol/$CONTRACT.json | jq '
        .ast.nodes |
        map(.nodes) |
        flatten |
        .[] |
        select(.kind=="function") |
        select(.stateMutability!="view") |
        select(.stateMutability!="pure") |
        select(.visibility=="external") |
        { name: .name, modifiers: .modifiers }' >> "$FILENAME"

    echo -e "\`\`\`" >> "$FILENAME"
done

# Run prettier so diff works properly.
npx prettier --write $FILENAME

log $GREEN "Done"
