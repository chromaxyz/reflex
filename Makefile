# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env
PROFILE?=default

# Setup
install:;
	forge install
	npm install

update:;
	forge update

# Clean
clean:; forge clean

# Build
build:; ./scripts/build.sh -p $(PROFILE)

# Test profiles
# - default
# - intense
# - min-solc
# - via-ir
# - min-solc-via-ir

# Test types
# - Unit
# - Differential
# - Fuzz
# - Invariant
# - Simulation

# Test
test:; ./scripts/test.sh -p $(PROFILE)
test-unit:; ./scripts/test.sh -t testUnit -p $(PROFILE)
test-fuzz:; ./scripts/test.sh -t testFuzz -p $(PROFILE)
test-invariant:; ./scripts/test.sh -d test/invariant -p $(PROFILE)
test-simulation:; ./scripts/test.sh -d test/simulation -p $(PROFILE)

# Snapshot
snapshot:; ./scripts/snapshot.sh -p $(PROFILE)

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
