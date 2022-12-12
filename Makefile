# Ignore instructions clashing with directory names
.PHONY: test

# Include .env file and export its variables
-include .env

# Setup
install:;
	forge install
	npm install

# Forge tasks
clean:; forge clean
build:; forge build --sizes
test:; forge test
trace:; forge test -vvvvv
snapshot:; forge snapshot

# Node tasks
lint-check:; npm run lint:check
lint-fix:; npm run lint:fix
