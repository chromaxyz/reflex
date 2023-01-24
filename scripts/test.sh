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

log $GREEN "Running tests"

export FOUNDRY_PROFILE=$PROFILE
echo Using profile: $FOUNDRY_PROFILE

if [ -z "$TEST" ];
then
    if [ -z "$DIRECTORY" ];
    then
        forge test;
    else
        forge test --match-path "$DIRECTORY/*.t.sol";
    fi
else
    forge test --match "$TEST";
fi

log $GREEN "Done"
