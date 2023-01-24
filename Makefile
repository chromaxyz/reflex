# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env

# Setup
install:;
	forge install
	npm install

update:;
	forge update

# Clean
clean:; forge clean

# Build
build:; forge build --sizes
# build-min-solc:; FOUNDRY_PROFILE=min-solc forge build --sizes
# build-via-ir:; FOUNDRY_PROFILE=via-ir forge build --sizes
# build-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge build --sizes

## Test types
# - Unit
# - Differential
# - Fuzz
# - Invariant
# - Simulation

# Test
test:; forge test
# test-intense:; FOUNDRY_PROFILE=intense forge test
# test-min-solc:; FOUNDRY_PROFILE=min-solc forge test
# test-via-ir:; FOUNDRY_PROFILE=via-ir forge test
# test-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge test

test-unit:; ./scripts/test.sh -d test/unit -p $(PROFILE)
test-fuzz:; ./scripts/test.sh -d test/fuzz -p $(PROFILE)
test-invariant:; ./scripts/test.sh -d test/invariant -p $(PROFILE)
test-simulation:; ./scripts/test.sh -d test/simulation -p $(PROFILE)

# Snapshot
snapshot:; forge snapshot --snap .gas-snapshot
# snapshot-min-solc:; FOUNDRY_PROFILE=min-solc forge snapshot --snap .gas-snapshot-min-solc
# snapshot-via-ir:; FOUNDRY_PROFILE=via-ir forge snapshot --snap .gas-snapshot-via-ir
# snapshot-min-solc-via-ir:; FOUNDRY_PROFILE=min-solc-via-ir forge snapshot --snap .gas-snapshot-min-solc-via-ir

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
