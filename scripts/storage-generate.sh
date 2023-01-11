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
CONTRACTS="BaseDispatcher ImplementationDispatcher"
FILENAME=.storage-layout

# Remove previous storage layout
rm -f $FILENAME

log $GREEN "Creating storage overview"

for CONTRACT in ${CONTRACTS[@]}
do
  {
    echo -e "\n**";
    echo "$CONTRACT";
    echo -e "**\n";
  } >> "$FILENAME"

  forge inspect --pretty "$CONTRACT" storage-layout >> "$FILENAME"

  echo "Generated storage layout for $CONTRACT."
done

log $GREEN "Done"
