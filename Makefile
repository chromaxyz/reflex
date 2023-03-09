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

ifeq ($(PROFILE),bounded)
test-invariant:; ./scripts/test.sh -c Bounded -p $(PROFILE)
else ifeq ($(PROFILE),unbounded)
test-invariant:; ./scripts/test.sh -c Unbounded -p $(PROFILE)
else
test-invariant:; ./scripts/test.sh -t invariant -p $(PROFILE)
endif

# Snapshot
snapshot:; ./scripts/snapshot.sh -t testGas -p $(PROFILE)

# Coverage
coverage:; ./scripts/coverage.sh

# Linting
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
