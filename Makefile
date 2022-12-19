# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env

# Setup
install:;
	forge install
	npm install

# Clean
clean:; forge clean

# Build
build:; forge build --sizes
build-ir:; FOUNDRY_PROFILE=via-ir forge build --sizes

# Test
test:; forge test
test-ir:; FOUNDRY_PROFILE=via-ir forge test
test-intense:; FOUNDRY_PROFILE=intense forge test

# Snapshot
snapshot:; forge snapshot
snapshot-ir:; FOUNDRY_PROFILE=via-ir forge snapshot

# Node tasks
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
