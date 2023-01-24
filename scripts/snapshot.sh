#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

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
while getopts d:p:t: flag
do
    case "${flag}" in
        d) DIRECTORY=${OPTARG};;
        p) PROFILE=${OPTARG};;
        t) TEST=${OPTARG};;
    esac
done

# Set Foundry profile
export FOUNDRY_PROFILE=$PROFILE

log $GREEN "Creating snapshot with profile: $FOUNDRY_PROFILE"

if [ -z "$TEST" ];
then
    if [ -z "$DIRECTORY" ];
    then
        forge snapshot --snap .gas-snapshot-$PROFILE;
    else
        forge snapshot --match-path "$DIRECTORY/*.t.sol" --snap .gas-snapshot-$PROFILE;
    fi
else
    forge snapshot --match "$TEST" --snap .gas-snapshot-$PROFILE;
fi

log $GREEN "Done"
