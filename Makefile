# Ignore instructions clashing with directory names
.PHONY: test docs

# Include .env file and export its variables
-include .env

# Profiles: `default`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`
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
gas:; ./scripts/test.sh -p $(PROFILE) -s "test(Gas)" -v 3
storage:; ./scripts/test.sh -p $(PROFILE) -s "test(Unit|Fuzz)Storage" -v 3

# Test a single method
# test-single:; ./scripts/test.sh -p PROFILE_NAME -s TEST_NAME -v VERBOSITY
# Where PROFILE_NAME (-p) is one of `default`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`.
# Where SCOPE (-s) is for example `testUnitMetadata`.
# Where VERBOSITY (-v) is for example `3`.

# ABI
abi:; ./scripts/abi-generate.sh

# Coverage
coverage:; ./scripts/coverage.sh

# Docs
docs:; ./scripts/docs-generate.sh

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix

# Reentrancy
reentrancy:; ./scripts/reentrancy-generate.sh

# Slither
slither:; ./scripts/slither-checklist.sh

# Snapshot
snapshot:; ./scripts/snapshot.sh -p $(PROFILE) -s "test(Unit|Fuzz|Gas)"
