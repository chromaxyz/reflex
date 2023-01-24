# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env

# Profiles: `default`, `bounded`, `unbounded`, `intense`, `min-solc`, `via-ir`, `min-solc-via-ir`
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
test:; ./scripts/test.sh -p $(PROFILE)
test-unit:; ./scripts/test.sh -t testUnit -p $(PROFILE)
test-fuzz:; ./scripts/test.sh -t testFuzz -p $(PROFILE)
test-invariant:; ./scripts/test.sh -t invariant -p $(PROFILE)

# Snapshot
snapshot:; ./scripts/snapshot.sh -p $(PROFILE)

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
