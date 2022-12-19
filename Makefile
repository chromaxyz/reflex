# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env

# Setup
install:;
	forge install
	npm install

# Base Forge tasks
clean:; forge clean
build:; forge build --sizes
test:; forge test
trace:; forge test -vvvvv
snapshot:; forge snapshot

# Extended Forge tasks
# build-ir:; FOUNDRY_PROFILE=via-ir make build
# test-ir:; FOUNDRY_PROFILE=via-ir make test
# test-intense:; FOUNDRY_PROFILE=intense make test

# Node tasks
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
