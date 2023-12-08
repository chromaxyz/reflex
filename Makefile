# Ignore instructions clashing with directory names
.PHONY: test docs

# Include .env file and export its variables
-include .env

# Build profiles: `default`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`
PROFILE?=default

# Setup
install:;
	forge install
	npm install

# Update
update:;
	forge update

# Clean
clean:; forge clean

# Build
build:; ./scripts/build.sh -p $(PROFILE)

# Test
test:; ./scripts/test.sh -p $(PROFILE) -s "test(Unit|Fuzz)"
test-gas:; ./scripts/test.sh -p $(PROFILE) -s "test(Gas)" -v 3
test-storage:; ./scripts/test.sh -p $(PROFILE) -s "test(Unit|Fuzz)Storage" -v 3

# Test a single method
# test-single:; ./scripts/test.sh -p PROFILE_NAME -s TEST_NAME -v VERBOSITY
# Where PROFILE_NAME (-p) is one of `default`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`.
# Where SCOPE (-s) is for example `testUnitMetadata`.
# Where VERBOSITY (-v) is for example `3`.

# Coverage
coverage:; ./scripts/coverage.sh

# Snapshot
snapshot:; ./scripts/snapshot.sh -p $(PROFILE) -s "test(Unit|Fuzz|Gas)"

# Reentrancy
reentrancy:; ./scripts/reentrancy-generate.sh

# Slither
slither:; ./scripts/slither-checklist.sh

# Storage
storage:; ./scripts/storage-generate.sh

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
