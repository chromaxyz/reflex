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

# Test a single method
# test-single:; ./scripts/test.sh -p PROFILE_NAME -s TEST_NAME -v VERBOSITY
# Where PROFILE_NAME is one of `default`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`.
# Where TEST_NAME is for example `testUnitMetadata`.
# Where VERBOSITY is for example `3`.

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

# Storage
storage:; ./scripts/storage-generate.sh

