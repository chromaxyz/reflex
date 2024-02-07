# Changelog

# 0.0.0

- Deprecated `simulateBatchCallReturn` and changed `simulateBatchCallRevert` to `simulateBatchCall`.
- Removed `_afterBatchCall(..)` from `simulateBatchCall` to support simulating reverting transactions.

# 0.1.0

- Changed `ReflexState` to `ReflexStorage` and updated test suite accordingly.
- Changed `_deployer` to `_DISPATCHER` in `ReflexEndpoint`.
