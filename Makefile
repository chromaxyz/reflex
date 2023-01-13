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
build-min-solc:; FOUNDRY_PROFILE=min-solc forge build --sizes
build-via-ir:; FOUNDRY_PROFILE=via-ir forge build --sizes
build-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge build --sizes

# Test
test:; forge test
test-intense:; FOUNDRY_PROFILE=intense forge test
test-min-solc:; FOUNDRY_PROFILE=min-solc forge test
test-via-ir:; FOUNDRY_PROFILE=via-ir forge test
test-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge test

# Snapshot
snapshot:; forge snapshot --snap .gas-snapshot
snapshot-min-solc:; FOUNDRY_PROFILE=min-solc forge snapshot --snap .gas-snapshot-min-solc
snapshot-via-ir:; FOUNDRY_PROFILE=via-ir forge snapshot --snap .gas-snapshot-via-ir
snapshot-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge snapshot --snap .gas-snapshot-min-solc-via-ir

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
