/// @use-src 19:"src/ReflexConstants.sol", 23:"src/ReflexModule.sol", 24:"src/ReflexState.sol", 28:"src/interfaces/IReflexModule.sol", 29:"src/interfaces/IReflexState.sol", 30:"src/periphery/ReflexBatch.sol", 31:"src/periphery/interfaces/IReflexBatch.sol", 44:"test/fixtures/MockHarness.sol", 54:"test/mocks/MockReflexBatch.sol", 58:"test/mocks/MockReflexModule.sol"
object "MockReflexBatch_41177" {
    code {
        {
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            let _1 := memoryguard(0xc0)
            if callvalue() { revert(0, 0) }
            let programSize := datasize("MockReflexBatch_41177")
            let argSize := sub(codesize(), programSize)
            let newFreePtr := add(_1, and(add(argSize, 31), not(31)))
            let _2 := sub(shl(64, 1), 1)
            if or(gt(newFreePtr, _2), lt(newFreePtr, _1))
            {
                mstore(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x41)
                revert(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x24)
            }
            let _3 := 64
            mstore(_3, newFreePtr)
            codecopy(_1, programSize, argSize)
            if slt(sub(add(_1, argSize), _1), _3)
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            let memPtr := mload(_3)
            let newFreePtr_1 := add(memPtr, _3)
            if or(gt(newFreePtr_1, _2), lt(newFreePtr_1, memPtr))
            {
                mstore(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ shl(224, 0x4e487b71))
                mstore(4, 0x41)
                revert(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x24)
            }
            mstore(_3, newFreePtr_1)
            let value := mload(_1)
            let _4 := 0xffffffff
            if iszero(eq(value, and(value, _4)))
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            mstore(memPtr, value)
            let value_1 := mload(add(_1, 32))
            let _5 := 0xffff
            if iszero(eq(value_1, and(value_1, _5)))
            {
                revert(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            let _6 := add(memPtr, 32)
            mstore(_6, value_1)
            /// @src 44:920:1319  "assembly (\"memory-safe\") {..."
            let _7 := mload(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3)
            /// @src 44:920:1319  "assembly (\"memory-safe\") {..."
            let _8 := or(calldataload(/** @src -1:-1:-1 */ 0), /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ _7)
            mstore(/** @src -1:-1:-1 */ 0, /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ _8)
            mstore(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32, /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ or(caller(), _8))
            let _9 := keccak256(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3)
            /// @src 44:920:1319  "assembly (\"memory-safe\") {..."
            let _10 := add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32, /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ _7)
            mstore(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3, /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ _10)
            mstore(/** @src -1:-1:-1 */ 0, /** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ shl(160, _9))
            /// @src 44:712:768  "if (!brutalizedAddressIsBrutalized) revert FailedSetup()"
            if /** @src 44:586:702  "assembly (\"memory-safe\") {..." */ iszero(and(/** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ _9, /** @src 44:586:702  "assembly (\"memory-safe\") {..." */ sub(shl(96, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 1), 1)))
            /// @src 44:712:768  "if (!brutalizedAddressIsBrutalized) revert FailedSetup()"
            {
                /// @src 44:755:768  "FailedSetup()"
                mstore(_10, shl(229, 0x02f0bef3))
                revert(_10, 4)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            let cleaned := and(mload(/** @src 23:2578:2602  "moduleSettings_.moduleId" */ memPtr), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _4)
            /// @src 23:2574:2657  "if (moduleSettings_.moduleId == 0) revert ModuleIdInvalid(moduleSettings_.moduleId)"
            if /** @src 23:2578:2607  "moduleSettings_.moduleId == 0" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ cleaned)
            /// @src 23:2574:2657  "if (moduleSettings_.moduleId == 0) revert ModuleIdInvalid(moduleSettings_.moduleId)"
            {
                /// @src 23:2616:2657  "ModuleIdInvalid(moduleSettings_.moduleId)"
                let _11 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(_3)
                /// @src 23:2616:2657  "ModuleIdInvalid(moduleSettings_.moduleId)"
                mstore(_11, shl(225, 0x06a01e81))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(/** @src 23:2616:2657  "ModuleIdInvalid(moduleSettings_.moduleId)" */ add(_11, 4), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ cleaned)
                /// @src 23:2616:2657  "ModuleIdInvalid(moduleSettings_.moduleId)"
                revert(_11, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 36)
            }
            let cleaned_1 := and(mload(/** @src 23:2671:2697  "moduleSettings_.moduleType" */ _6), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _5)
            /// @src 23:2671:2756  "moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL"
            let expr := /** @src 23:2671:2702  "moduleSettings_.moduleType == 0" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ cleaned_1)
            /// @src 23:2671:2756  "moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL"
            if iszero(expr)
            {
                expr := /** @src 23:2706:2756  "moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL" */ gt(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ cleaned_1, /** @src 19:1064:1065  "3" */ 0x03)
            }
            /// @src 23:2667:2822  "if (moduleSettings_.moduleType == 0 || moduleSettings_.moduleType > _MODULE_TYPE_INTERNAL)..."
            if expr
            {
                /// @src 23:2777:2822  "ModuleTypeInvalid(moduleSettings_.moduleType)"
                let _12 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(_3)
                /// @src 23:2777:2822  "ModuleTypeInvalid(moduleSettings_.moduleType)"
                mstore(_12, shl(224, 0xf09668e9))
                /// @src 19:1064:1065  "3"
                mstore(/** @src 23:2777:2822  "ModuleTypeInvalid(moduleSettings_.moduleType)" */ add(_12, 4), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ cleaned_1)
                /// @src 23:2777:2822  "ModuleTypeInvalid(moduleSettings_.moduleType)"
                revert(_12, /** @src 19:1064:1065  "3" */ 36)
            }
            /// @src 23:2833:2869  "_moduleId = moduleSettings_.moduleId"
            mstore(128, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(mload(/** @src 23:2845:2869  "moduleSettings_.moduleId" */ memPtr), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _4))
            /// @src 23:2879:2919  "_moduleType = moduleSettings_.moduleType"
            mstore(/** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ 160, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(mload(/** @src 23:2893:2919  "moduleSettings_.moduleType" */ _6), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _5))
            /// @src 19:367:368  "1"
            sstore(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041, /** @src 19:367:368  "1" */ 0x01)
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            let _13 := mload(_3)
            let _14 := datasize("MockReflexBatch_41177_deployed")
            codecopy(_13, dataoffset("MockReflexBatch_41177_deployed"), _14)
            setimmutable(_13, "27677", mload(/** @src 23:2833:2869  "_moduleId = moduleSettings_.moduleId" */ 128))
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            setimmutable(_13, "27680", mload(/** @src 44:920:1319  "assembly (\"memory-safe\") {..." */ 160))
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            return(_13, _14)
        }
    }
    /// @use-src 19:"src/ReflexConstants.sol", 23:"src/ReflexModule.sol", 24:"src/ReflexState.sol", 30:"src/periphery/ReflexBatch.sol", 54:"test/mocks/MockReflexBatch.sol", 58:"test/mocks/MockReflexModule.sol"
    object "MockReflexBatch_41177_deployed" {
        code {
            {
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(64, 128)
                if iszero(lt(calldatasize(), 4))
                {
                    switch shr(224, calldataload(0))
                    case 0x054ef57d {
                        external_fun_unpackMessageSender()
                    }
                    case 0x083b2732 { external_fun_callback() }
                    case 0x0e70a9a3 {
                        external_fun_endpointLog3Topic()
                    }
                    case 0x1aa9eded {
                        external_fun_revertEndpointLogOutOfBounds()
                    }
                    case 0x207d02fd {
                        external_fun_unguardedCheckUnlocked()
                    }
                    case 0x26b405c0 {
                        external_fun_readCallbackTargetUnprotected()
                    }
                    case 0x287e84d3 {
                        external_fun_revertPanicAssert()
                    }
                    case 0x3460ad4c {
                        external_fun_guardedCheckLocked()
                    }
                    case 0x347cad88 {
                        external_fun_unpackEndpointAddress()
                    }
                    case 0x34a589d6 {
                        external_fun_readGuardedCheckProtected()
                    }
                    case 0x3f7e1dc0 {
                        external_fun_revertPanicArithmeticUnderflow()
                    }
                    case 0x42a656b8 {
                        external_fun_callInternalModule()
                    }
                    case 0x495a54c0 {
                        external_fun_endpointLog0Topic()
                    }
                    case 0x58a50b2e {
                        external_fun_performBatchCall()
                    }
                    case 0x5b30263e {
                        external_fun_revertPanicArithmeticOverflow()
                    }
                    case 0x610f1566 {
                        external_fun_countIndirectRecursive()
                    }
                    case 0x63559e81 {
                        external_fun_revertBytesCustomError()
                    }
                    case 0x63642e54 {
                        external_fun_readCallbackTargetProtected()
                    }
                    case 0x6465e69f { external_fun_moduleType() }
                    case 0x6ebb63d9 {
                        external_fun_reentrancyCounter()
                    }
                    case 0x6ee7576c {
                        external_fun_afterBatchCallCounter()
                    }
                    case 0x703fca0f {
                        external_fun_simulateBatchCallReturn()
                    }
                    case 0x70edd423 {
                        external_fun_guardedCheckLocked()
                    }
                    case 0x7552b589 { external_fun_createEndpoint() }
                    case 0x78c6574b {
                        external_fun_beforeBatchCallCounter()
                    }
                    case 0x89ff19f9 {
                        external_fun_endpointLog4Topic()
                    }
                    case 0x97d7c61b {
                        external_fun_unpackTrailingParameters()
                    }
                    case 0xa1308f27 { external_fun_moduleId() }
                    case 0xb672ad8b { external_fun_countAndCall() }
                    case 0xc3b0c3b4 {
                        external_fun_isReentrancyStatusLocked()
                    }
                    case 0xc460d860 {
                        external_fun_endpointLog2Topic()
                    }
                    case 0xc7a199df {
                        external_fun_revertPanicDivisionByZero()
                    }
                    case 0xcc71c447 { external_fun_moduleSettings() }
                    case 0xcccee849 {
                        external_fun_performStaticCall()
                    }
                    case 0xd13b56d2 {
                        external_fun_getReentrancyStatus()
                    }
                    case 0xd9399236 {
                        external_fun_countDirectRecursive()
                    }
                    case 0xe0d325a8 { external_fun_revertBytes() }
                    case 0xe2e0e974 {
                        external_fun_simulateBatchCallRevert()
                    }
                    case 0xf5bb5ed5 {
                        external_fun_endpointLog1Topic()
                    }
                }
                revert(0, 0)
            }
            function external_fun_unpackMessageSender()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPos := mload(64)
                mstore(memPos, /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8))))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(memPos, 32)
            }
            function external_fun_callback()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d"
                let _3 := 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3), /** @src 19:367:368  "1" */ 0x01))
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:367:368  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(0, 0)
            }
            function panic_error_0x41()
            {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x41)
                revert(0, 0x24)
            }
            function finalize_allocation_9608(memPtr)
            {
                if gt(memPtr, 0xffffffffffffffff) { panic_error_0x41() }
                mstore(64, memPtr)
            }
            function finalize_allocation_9611(memPtr)
            {
                let newFreePtr := add(memPtr, 64)
                if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
                mstore(64, newFreePtr)
            }
            function finalize_allocation(memPtr, size)
            {
                let newFreePtr := add(memPtr, and(add(size, 31), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0))
                if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
                mstore(64, newFreePtr)
            }
            function allocate_memory() -> memPtr
            {
                memPtr := mload(64)
                finalize_allocation_9611(memPtr)
            }
            function array_allocation_size_bytes(length) -> size
            {
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }
                size := add(and(add(length, 31), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), 0x20)
            }
            function abi_decode_bytes_memory_ptr(offset, end) -> array
            {
                if iszero(slt(add(offset, 0x1f), end)) { revert(0, 0) }
                let _1 := calldataload(offset)
                let _2 := array_allocation_size_bytes(_1)
                let memPtr := mload(64)
                finalize_allocation(memPtr, _2)
                mstore(memPtr, _1)
                if gt(add(add(offset, _1), 0x20), end)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                calldatacopy(add(memPtr, 0x20), add(offset, 0x20), _1)
                mstore(add(add(memPtr, _1), 0x20), /** @src -1:-1:-1 */ 0)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                array := memPtr
            }
            function abi_decode_bytes(dataEnd) -> value0
            {
                if slt(add(dataEnd, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32) { revert(0, 0) }
                let offset := calldataload(4)
                if gt(offset, 0xffffffffffffffff) { revert(0, 0) }
                value0 := abi_decode_bytes_memory_ptr(add(4, offset), dataEnd)
            }
            function external_fun_endpointLog3Topic()
            {
                if callvalue() { revert(0, 0) }
                let _1 := abi_decode_bytes(calldatasize())
                /// @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ add(expr_mpos, 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x0300000000000000000000000000000000000000000000000000000000000000)
                mstore(add(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), /** @src 58:3042:3043  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65), /** @src 58:3063:3064  "2" */ 0x02)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97), /** @src 58:3022:3023  "3" */ 0x03)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let length := mload(_1)
                copy_memory_to_memory_with_cleanup(add(_1, /** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 129), length)
                /// @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)"
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ length), /** @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)" */ expr_mpos)
                mstore(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97))
                /// @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)"
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 129))
                /// @src 58:2999:3098  "abi.encodePacked(uint8(3), bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), message_)"
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_revertEndpointLogOutOfBounds()
            {
                if callvalue() { revert(0, 0) }
                let _1 := abi_decode_bytes(calldatasize())
                /// @src 58:3589:3856  "abi.encodePacked(..."
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:3589:3856  "abi.encodePacked(..." */ add(expr_mpos, 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x0500000000000000000000000000000000000000000000000000000000000000)
                mstore(add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), /** @src 58:3665:3666  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65), /** @src 58:3702:3703  "2" */ 0x02)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97), /** @src 58:3739:3740  "3" */ 0x03)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 129), 4)
                mstore(add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 161), /** @src 58:3629:3630  "5" */ 0x05)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let length := mload(_1)
                copy_memory_to_memory_with_cleanup(add(_1, /** @src 58:3589:3856  "abi.encodePacked(..." */ 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 193), length)
                /// @src 58:3589:3856  "abi.encodePacked(..."
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ length), /** @src 58:3589:3856  "abi.encodePacked(..." */ expr_mpos)
                mstore(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 161))
                /// @src 58:3589:3856  "abi.encodePacked(..."
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 193))
                /// @src 58:3589:3856  "abi.encodePacked(..."
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_unguardedCheckUnlocked()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let _1 := sload(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041)
                /// @src 58:6402:6437  "assert(!isReentrancyStatusLocked())"
                assert_helper(/** @src 58:6409:6436  "!isReentrancyStatusLocked()" */ iszero(/** @src 58:4634:4696  "_REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED" */ eq(_1, /** @src 19:487:488  "2" */ 0x02)))
                /// @src 58:6447:6506  "assert(getReentrancyStatus() == _REENTRANCY_GUARD_UNLOCKED)"
                assert_helper(/** @src 58:6454:6505  "getReentrancyStatus() == _REENTRANCY_GUARD_UNLOCKED" */ eq(_1, /** @src 19:367:368  "1" */ 0x01))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(0, 0)
            }
            function external_fun_readCallbackTargetUnprotected()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                return(0, 0)
            }
            function external_fun_revertPanicAssert()
            {
                if callvalue() { revert(0, 0) }
                let _1 := 0
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                /// @src 58:1484:1502  "new PanicThrower()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1484:1502  "new PanicThrower()"
                let _3 := datasize("PanicThrower_42197")
                let _4 := add(_2, _3)
                if or(gt(_4, 0xffffffffffffffff), lt(_4, _2)) { panic_error_0x41() }
                datacopy(_2, dataoffset("PanicThrower_42197"), _3)
                let expr_address := create(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, /** @src 58:1484:1502  "new PanicThrower()" */ _2, sub(_4, _2))
                if iszero(expr_address) { revert_forward() }
                /// @src 58:1559:1604  "abi.encodeWithSignature(\"throwPanicAssert()\")"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1559:1604  "abi.encodeWithSignature(\"throwPanicAssert()\")"
                let _5 := add(expr_mpos, 0x20)
                mstore(_5, 0x6601d57600000000000000000000000000000000000000000000000000000000)
                mstore(expr_mpos, 4)
                finalize_allocation_9611(expr_mpos)
                /// @src 58:1537:1605  "address(thrower).call(abi.encodeWithSignature(\"throwPanicAssert()\"))"
                pop(call(gas(), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 58:1537:1553  "address(thrower)" */ expr_address, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff), _1, /** @src 58:1537:1605  "address(thrower).call(abi.encodeWithSignature(\"throwPanicAssert()\"))" */ _5, mload(expr_mpos), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, _1))
                /// @src 58:1629:1633  "data"
                fun_revertBytes(/** @src 58:1537:1605  "address(thrower).call(abi.encodeWithSignature(\"throwPanicAssert()\"))" */ extract_returndata())
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_guardedCheckLocked()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:367:368  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(0, 0)
            }
            function external_fun_unpackEndpointAddress()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPos := mload(64)
                mstore(memPos, /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec))))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(memPos, 32)
            }
            function external_fun_readGuardedCheckProtected()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_1, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 23:2125:2145  "ReadOnlyReentrancy()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 23:2125:2145  "ReadOnlyReentrancy()"
                mstore(_2, 33383833486055025257622456013617326011422323105436034009855931607588043489280)
                revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
            }
            function external_fun_revertPanicArithmeticUnderflow()
            {
                if callvalue() { revert(0, 0) }
                let _1 := 0
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                /// @src 58:2239:2257  "new PanicThrower()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:2239:2257  "new PanicThrower()"
                let _3 := datasize("PanicThrower_42197")
                let _4 := add(_2, _3)
                if or(gt(_4, 0xffffffffffffffff), lt(_4, _2)) { panic_error_0x41() }
                datacopy(_2, dataoffset("PanicThrower_42197"), _3)
                let expr_address := create(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, /** @src 58:2239:2257  "new PanicThrower()" */ _2, sub(_4, _2))
                if iszero(expr_address) { revert_forward() }
                /// @src 58:2314:2372  "abi.encodeWithSignature(\"throwPanicArithmeticUnderflow()\")"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:2314:2372  "abi.encodeWithSignature(\"throwPanicArithmeticUnderflow()\")"
                let _5 := add(expr_mpos, 0x20)
                mstore(_5, 0xed24c55a00000000000000000000000000000000000000000000000000000000)
                mstore(expr_mpos, 4)
                finalize_allocation_9611(expr_mpos)
                /// @src 58:2292:2373  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticUnderflow()\"))"
                pop(call(gas(), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 58:2292:2308  "address(thrower)" */ expr_address, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff), _1, /** @src 58:2292:2373  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticUnderflow()\"))" */ _5, mload(expr_mpos), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, _1))
                /// @src 58:2397:2401  "data"
                fun_revertBytes(/** @src 58:2292:2373  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticUnderflow()\"))" */ extract_returndata())
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function abi_decode_uint32() -> value
            {
                value := calldataload(4)
                if iszero(eq(value, and(value, 0xffffffff))) { revert(0, 0) }
            }
            function copy_memory_to_memory_with_cleanup(src, dst, length)
            {
                let i := 0
                for { } lt(i, length) { i := add(i, 32) }
                {
                    mstore(add(dst, i), mload(add(src, i)))
                }
                mstore(add(dst, length), 0)
            }
            function abi_encode_bytes(value, pos) -> end
            {
                let length := mload(value)
                mstore(pos, length)
                copy_memory_to_memory_with_cleanup(add(value, 0x20), add(pos, 0x20), length)
                end := add(add(pos, and(add(length, 31), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0)), 0x20)
            }
            function external_fun_callInternalModule()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 64)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value0 := abi_decode_uint32()
                let offset := calldataload(36)
                if gt(offset, 0xffffffffffffffff)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value1 := abi_decode_bytes_memory_ptr(add(4, offset), calldatasize())
                let cleaned := and(sload(/** @src 23:5726:5762  "_REFLEX_STORAGE().modules[moduleId_]" */ mapping_index_access_mapping_uint32_address_of_uint32(value0)), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff)
                /// @src 23:5726:5783  "_REFLEX_STORAGE().modules[moduleId_].delegatecall(input_)"
                let expr_component := delegatecall(gas(), cleaned, add(value1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32), /** @src 23:5726:5783  "_REFLEX_STORAGE().modules[moduleId_].delegatecall(input_)" */ mload(value1), /** @src -1:-1:-1 */ 0, 0)
                /// @src 23:5726:5783  "_REFLEX_STORAGE().modules[moduleId_].delegatecall(input_)"
                let expr_component_mpos := extract_returndata()
                /// @src 23:5794:5828  "if (!success) _revertBytes(result)"
                if /** @src 23:5798:5806  "!success" */ iszero(expr_component)
                /// @src 23:5794:5828  "if (!success) _revertBytes(result)"
                {
                    /// @src 23:5821:5827  "result"
                    fun_revertBytes(expr_component_mpos)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, 32)
                return(memPos, sub(abi_encode_bytes(expr_component_mpos, add(memPos, 32)), memPos))
            }
            function external_fun_endpointLog0Topic()
            {
                if callvalue() { revert(0, 0) }
                let _1 := abi_decode_bytes(calldatasize())
                /// @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)" */ add(expr_mpos, 0x20), /** @src 58:2527:2528  "0" */ 0x00)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let length := mload(_1)
                copy_memory_to_memory_with_cleanup(add(_1, /** @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)" */ 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), length)
                /// @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)"
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ length), /** @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)" */ expr_mpos)
                mstore(expr_mpos, add(_2, 1))
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33))
                /// @src 58:2504:2540  "abi.encodePacked(uint8(0), message_)"
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src 58:2527:2528  "0" */ 0x00, 0x00)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function abi_decode_array_struct_BatchAction_calldata_dyn_calldata(dataEnd) -> value0, value1
            {
                if slt(add(dataEnd, 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32) { revert(0, 0) }
                let offset := calldataload(4)
                let _1 := 0xffffffffffffffff
                if gt(offset, _1) { revert(0, 0) }
                if iszero(slt(add(offset, 35), dataEnd))
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let length := calldataload(add(4, offset))
                if gt(length, _1)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                if gt(add(add(offset, shl(5, length)), 36), dataEnd)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                value0 := add(offset, 36)
                value1 := length
            }
            function external_fun_performBatchCall()
            {
                if callvalue() { revert(0, 0) }
                let param, param_1 := abi_decode_array_struct_BatchAction_calldata_dyn_calldata(calldatasize())
                /// @src 30:1105:1127  "_unpackMessageSender()"
                let expr := /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8)))
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                let _1 := 1
                /// @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177"
                let _2 := 0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177" */ _2, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177" */ _2), /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ _1))
                /// @src 30:1234:1247  "uint256 i = 0"
                let var_i := /** @src 30:1246:1247  "0" */ 0x00
                /// @src 30:1229:1565  "for (uint256 i = 0; i < actionsLength; ) {..."
                for { }
                /** @src 30:1249:1266  "i < actionsLength" */ lt(var_i, param_1)
                /// @src 30:1234:1247  "uint256 i = 0"
                { }
                {
                    /// @src 30:1314:1325  "actions_[i]"
                    let expr_offset := calldata_array_index_access_struct_BatchAction_calldata_dyn_calldata(param, param_1, var_i)
                    /// @src 30:1378:1420  "_performBatchAction(messageSender, action)"
                    let expr_component, expr_component_mpos := fun_performBatchAction(expr, expr_offset)
                    /// @src 30:1441:1471  "success || action.allowFailure"
                    let expr_1 := expr_component
                    if iszero(expr_component)
                    {
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        let value := calldataload(/** @src 30:1452:1471  "action.allowFailure" */ add(expr_offset, 32))
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        validator_revert_bool(value)
                        /// @src 30:1441:1471  "success || action.allowFailure"
                        expr_1 := value
                    }
                    /// @src 30:1435:1494  "if (!(success || action.allowFailure)) _revertBytes(result)"
                    if /** @src 30:1439:1472  "!(success || action.allowFailure)" */ iszero(expr_1)
                    /// @src 30:1435:1494  "if (!(success || action.allowFailure)) _revertBytes(result)"
                    {
                        /// @src 30:1487:1493  "result"
                        fun_revertBytes(expr_component_mpos)
                    }
                    /// @src 30:1537:1540  "++i"
                    var_i := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 30:1537:1540  "++i" */ var_i, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ _1)
                }
                /// @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64"
                let _3 := 0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64" */ _3), /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ _1))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src 30:1246:1247  "0" */ 0x00, 0x00)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_revertPanicArithmeticOverflow()
            {
                if callvalue() { revert(0, 0) }
                let _1 := 0
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                /// @src 58:1980:1998  "new PanicThrower()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1980:1998  "new PanicThrower()"
                let _3 := datasize("PanicThrower_42197")
                let _4 := add(_2, _3)
                if or(gt(_4, 0xffffffffffffffff), lt(_4, _2)) { panic_error_0x41() }
                datacopy(_2, dataoffset("PanicThrower_42197"), _3)
                let expr_address := create(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, /** @src 58:1980:1998  "new PanicThrower()" */ _2, sub(_4, _2))
                if iszero(expr_address) { revert_forward() }
                /// @src 58:2055:2112  "abi.encodeWithSignature(\"throwPanicArithmeticOverflow()\")"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:2055:2112  "abi.encodeWithSignature(\"throwPanicArithmeticOverflow()\")"
                let _5 := add(expr_mpos, 0x20)
                mstore(_5, 0x0643cd0500000000000000000000000000000000000000000000000000000000)
                mstore(expr_mpos, 4)
                finalize_allocation_9611(expr_mpos)
                /// @src 58:2033:2113  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticOverflow()\"))"
                pop(call(gas(), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 58:2033:2049  "address(thrower)" */ expr_address, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff), _1, /** @src 58:2033:2113  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticOverflow()\"))" */ _5, mload(expr_mpos), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, _1))
                /// @src 58:2137:2141  "data"
                fun_revertBytes(/** @src 58:2033:2113  "address(thrower).call(abi.encodeWithSignature(\"throwPanicArithmeticOverflow()\"))" */ extract_returndata())
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_countIndirectRecursive()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value0 := calldataload(4)
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:487:488  "2" */ 0x02)
                /// @src 58:5095:5388  "if (n_ > 0) {..."
                if /** @src 58:5099:5105  "n_ > 0" */ iszero(iszero(value0))
                /// @src 58:5095:5388  "if (n_ > 0) {..."
                {
                    /// @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d"
                    let _3 := 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d
                    /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                    sstore(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3), /** @src 19:367:368  "1" */ 0x01))
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let diff := add(value0, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                    if gt(diff, value0)
                    {
                        mstore(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                        mstore(4, 0x11)
                        revert(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x24)
                    }
                    /// @src 58:5250:5316  "abi.encodeWithSignature(\"countIndirectRecursive(uint256)\", n_ - 1)"
                    let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 58:5250:5316  "abi.encodeWithSignature(\"countIndirectRecursive(uint256)\", n_ - 1)"
                    let _4 := add(expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32)
                    /// @src 58:5250:5316  "abi.encodeWithSignature(\"countIndirectRecursive(uint256)\", n_ - 1)"
                    mstore(_4, 0x610f156600000000000000000000000000000000000000000000000000000000)
                    let _5 := sub(abi_encode_uint256(add(expr_mpos, 36), diff), expr_mpos)
                    mstore(expr_mpos, add(_5, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0))
                    finalize_allocation(expr_mpos, _5)
                    /// @src 58:5214:5330  "address(this).call(..."
                    let expr_component := call(gas(), /** @src 58:5222:5226  "this" */ address(), /** @src -1:-1:-1 */ 0, /** @src 58:5214:5330  "address(this).call(..." */ _4, mload(expr_mpos), /** @src -1:-1:-1 */ 0, 0)
                    /// @src 58:5214:5330  "address(this).call(..."
                    let expr_component_mpos := extract_returndata()
                    /// @src 58:5345:5377  "if (!success) _revertBytes(data)"
                    if /** @src 58:5349:5357  "!success" */ iszero(expr_component)
                    /// @src 58:5345:5377  "if (!success) _revertBytes(data)"
                    {
                        /// @src 58:5372:5376  "data"
                        fun_revertBytes(expr_component_mpos)
                    }
                }
                /// @src 23:1538:1601  "_REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED"
                update_storage_value_offsett_uint256_to_uint256()
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function abi_decode_string_calldata(offset, end) -> arrayPos, length
            {
                if iszero(slt(add(offset, 0x1f), end)) { revert(0, 0) }
                length := calldataload(offset)
                if gt(length, 0xffffffffffffffff) { revert(0, 0) }
                arrayPos := add(offset, 0x20)
                if gt(add(add(offset, length), 0x20), end) { revert(0, 0) }
            }
            function external_fun_revertBytesCustomError()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 64)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let offset := calldataload(36)
                let _1 := 0xffffffffffffffff
                if gt(offset, _1)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value1, value2 := abi_decode_string_calldata(add(4, offset), calldatasize())
                /// @src 58:1184:1208  "new CustomErrorThrower()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1184:1208  "new CustomErrorThrower()"
                let _3 := datasize("CustomErrorThrower_42142")
                let _4 := add(_2, _3)
                if or(gt(_4, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1), /** @src 58:1184:1208  "new CustomErrorThrower()" */ lt(_4, _2)) { panic_error_0x41() }
                datacopy(_2, dataoffset("CustomErrorThrower_42142"), _3)
                let expr_address := create(/** @src -1:-1:-1 */ 0, /** @src 58:1184:1208  "new CustomErrorThrower()" */ _2, sub(_4, _2))
                if iszero(expr_address) { revert_forward() }
                /// @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)"
                let _5 := add(expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32)
                /// @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)"
                mstore(_5, /** @src 58:1301:1345  "CustomErrorThrower.throwCustomError.selector" */ 0x60d2c0d500000000000000000000000000000000000000000000000000000000)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(/** @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)" */ add(expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 36), calldataload(4))
                mstore(add(/** @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 68), 64)
                /// @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)"
                let _6 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ abi_encode_bytes_calldata(value1, value2, add(/** @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 100)), /** @src 58:1278:1361  "abi.encodeWithSelector(CustomErrorThrower.throwCustomError.selector, code, message)" */ expr_mpos)
                mstore(expr_mpos, add(_6, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0))
                finalize_allocation(expr_mpos, _6)
                /// @src 58:1243:1371  "address(thrower).call(..."
                pop(call(gas(), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 58:1243:1259  "address(thrower)" */ expr_address, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff), /** @src -1:-1:-1 */ 0, /** @src 58:1243:1371  "address(thrower).call(..." */ _5, mload(expr_mpos), /** @src -1:-1:-1 */ 0, 0))
                /// @src 58:1395:1399  "data"
                fun_revertBytes(/** @src 58:1243:1371  "address(thrower).call(..." */ extract_returndata())
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_readCallbackTargetProtected()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 23:2050:2145  "if (_REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED) revert ReadOnlyReentrancy()"
                if /** @src 23:2054:2116  "_REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED" */ eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041), /** @src 19:487:488  "2" */ 0x02)
                /// @src 23:2050:2145  "if (_REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED) revert ReadOnlyReentrancy()"
                {
                    /// @src 23:2125:2145  "ReadOnlyReentrancy()"
                    let _1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:2125:2145  "ReadOnlyReentrancy()"
                    mstore(_1, 33383833486055025257622456013617326011422323105436034009855931607588043489280)
                    revert(_1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                return(0, 0)
            }
            function abi_encode_uint16(headStart, value0) -> tail
            {
                tail := add(headStart, 32)
                mstore(headStart, and(value0, 0xffff))
            }
            function external_fun_moduleType()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPos := mload(64)
                mstore(memPos, and(/** @src 23:3263:3274  "_moduleType" */ loadimmutable("27680"), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffff))
                return(memPos, 32)
            }
            function abi_encode_uint256(headStart, value0) -> tail
            {
                tail := add(headStart, 32)
                mstore(headStart, value0)
            }
            function external_fun_reentrancyCounter()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 58:7175:7242  "assembly (\"memory-safe\") {..."
                let var_n := sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, var_n)
                return(memPos, 32)
            }
            function external_fun_afterBatchCallCounter()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 58:7175:7242  "assembly (\"memory-safe\") {..."
                let var_n := sload(/** @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64" */ 0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, var_n)
                return(memPos, 32)
            }
            function abi_encode_array_struct_BatchActionResponse_dyn(headStart, value0) -> tail
            {
                let _1 := 32
                let tail_1 := add(headStart, _1)
                mstore(headStart, _1)
                let pos := tail_1
                let length := mload(value0)
                mstore(tail_1, length)
                let _2 := 64
                pos := add(headStart, _2)
                let tail_2 := add(add(headStart, shl(5, length)), _2)
                let srcPtr := add(value0, _1)
                let i := 0
                for { } lt(i, length) { i := add(i, 1) }
                {
                    mstore(pos, add(sub(tail_2, headStart), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc0))
                    let _3 := mload(srcPtr)
                    mstore(tail_2, iszero(iszero(mload(_3))))
                    let memberValue0 := mload(add(_3, _1))
                    mstore(add(tail_2, _1), _2)
                    tail_2 := abi_encode_bytes(memberValue0, add(tail_2, _2))
                    srcPtr := add(srcPtr, _1)
                    pos := add(pos, _1)
                }
                tail := tail_2
            }
            function external_fun_simulateBatchCallReturn()
            {
                if callvalue() { revert(0, 0) }
                let param, param_1 := abi_decode_array_struct_BatchAction_calldata_dyn_calldata(calldatasize())
                /// @src 30:2847:2883  "_REFLEX_STORAGE().modules[_moduleId]"
                let _1 := read_from_storage_split_offset_t_address(mapping_index_access_mapping_uint32_address_of_uint32(/** @src 30:2873:2882  "_moduleId" */ loadimmutable("27677")))
                /// @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)"
                mstore(add(expr_mpos, 0x20), /** @src 30:2967:3012  "IReflexBatch.simulateBatchCallRevert.selector" */ 0xe2e0e97400000000000000000000000000000000000000000000000000000000)
                /// @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)"
                let _2 := sub(abi_encode_array_struct_BatchAction_calldata_dyn_calldata(add(expr_mpos, 36), param, param_1), expr_mpos)
                let _3 := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0
                mstore(expr_mpos, add(_2, _3))
                finalize_allocation(expr_mpos, _2)
                /// @src 30:2910:3137  "abi.encodePacked(..."
                let expr_mpos_1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 30:2910:3137  "abi.encodePacked(..."
                let _4 := add(expr_mpos_1, /** @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)" */ 0x20)
                /// @src 30:2910:3137  "abi.encodePacked(..."
                let _5 := sub(abi_encode_packed_bytes_uint160_uint160(_4, expr_mpos, /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ shr(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 96, /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8))), /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ shr(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 96, /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec)))), /** @src 30:2910:3137  "abi.encodePacked(..." */ expr_mpos_1)
                mstore(expr_mpos_1, add(_5, /** @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)" */ _3))
                /// @src 30:2910:3137  "abi.encodePacked(..."
                finalize_allocation(expr_mpos_1, _5)
                /// @src 30:2847:3147  "_REFLEX_STORAGE().modules[_moduleId].delegatecall(..."
                let expr_component := delegatecall(gas(), _1, _4, mload(expr_mpos_1), /** @src -1:-1:-1 */ 0, 0)
                /// @src 30:2847:3147  "_REFLEX_STORAGE().modules[_moduleId].delegatecall(..."
                let expr_component_mpos := extract_returndata()
                /// @src 30:3158:3201  "if (success) revert BatchSimulationFailed()"
                if expr_component
                {
                    /// @src 30:3178:3201  "BatchSimulationFailed()"
                    let _6 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 30:3178:3201  "BatchSimulationFailed()"
                    mstore(_6, 111769424415293635643842660186592836784441776464460672915424096622386966691840)
                    revert(_6, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 30:3212:3280  "if (bytes4(result) != BatchSimulation.selector) _revertBytes(result)"
                if /** @src 30:3216:3258  "bytes4(result) != BatchSimulation.selector" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:3216:3230  "bytes4(result)" */ convert_bytes_to_fixedbytes_from_bytes_to_bytes4(expr_component_mpos), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff00000000000000000000000000000000000000000000000000000000), /** @src 30:3234:3258  "BatchSimulation.selector" */ 0x2f1604fa00000000000000000000000000000000000000000000000000000000))
                /// @src 30:3212:3280  "if (bytes4(result) != BatchSimulation.selector) _revertBytes(result)"
                {
                    /// @src 30:3273:3279  "result"
                    fun_revertBytes(expr_component_mpos)
                }
                /// @src 30:3358:3415  "simulation_ = abi.decode(result, (BatchActionResponse[]))"
                let var_simulation_mpos := /** @src 30:3372:3415  "abi.decode(result, (BatchActionResponse[]))" */ abi_decode_array_struct_BatchActionResponse_dyn_fromMemory(add(/** @src 30:3291:3348  "assembly {..." */ expr_component_mpos, /** @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)" */ 36), /** @src 30:3372:3415  "abi.decode(result, (BatchActionResponse[]))" */ add(add(/** @src 30:3291:3348  "assembly {..." */ expr_component_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(/** @src 30:3291:3348  "assembly {..." */ add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4, /** @src 30:3291:3348  "assembly {..." */ expr_component_mpos))), /** @src 30:2944:3023  "abi.encodeWithSelector(IReflexBatch.simulateBatchCallRevert.selector, actions_)" */ 36))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                return(memPos, sub(abi_encode_array_struct_BatchActionResponse_dyn(memPos, var_simulation_mpos), memPos))
            }
            function validator_revert_address(value)
            {
                if iszero(eq(value, and(value, 0xffffffffffffffffffffffffffffffffffffffff))) { revert(0, 0) }
            }
            function external_fun_createEndpoint()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 96)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value0 := abi_decode_uint32()
                let value := calldataload(36)
                if iszero(eq(value, and(value, 0xffff)))
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value_1 := calldataload(68)
                validator_revert_address(value_1)
                let ret := /** @src 58:6684:6746  "_createEndpoint(moduleId_, moduleType_, moduleImplementation_)" */ fun_createEndpoint(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ value0, value, value_1)
                let memPos := mload(64)
                mstore(memPos, and(ret, 0xffffffffffffffffffffffffffffffffffffffff))
                return(memPos, 32)
            }
            function external_fun_beforeBatchCallCounter()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 58:7175:7242  "assembly (\"memory-safe\") {..."
                let var_n := sload(/** @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177" */ 0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, var_n)
                return(memPos, 32)
            }
            function external_fun_endpointLog4Topic()
            {
                if callvalue() { revert(0, 0) }
                let _1 := abi_decode_bytes(calldatasize())
                /// @src 58:3223:3453  "abi.encodePacked(..."
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:3223:3453  "abi.encodePacked(..." */ add(expr_mpos, 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x0400000000000000000000000000000000000000000000000000000000000000)
                mstore(add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), /** @src 58:3299:3300  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65), /** @src 58:3336:3337  "2" */ 0x02)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97), /** @src 58:3373:3374  "3" */ 0x03)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 129), 4)
                let length := mload(_1)
                copy_memory_to_memory_with_cleanup(add(_1, /** @src 58:3223:3453  "abi.encodePacked(..." */ 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 161), length)
                /// @src 58:3223:3453  "abi.encodePacked(..."
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ length), /** @src 58:3223:3453  "abi.encodePacked(..." */ expr_mpos)
                mstore(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 129))
                /// @src 58:3223:3453  "abi.encodePacked(..."
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 161))
                /// @src 58:3223:3453  "abi.encodePacked(..."
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_unpackTrailingParameters()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPos := mload(64)
                mstore(memPos, /** @src 23:7209:7401  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:7209:7401  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8))))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(memPos, 32), /** @src 23:7209:7401  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:7209:7401  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec))))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(memPos, 64)
            }
            function abi_encode_uint32(headStart, value0) -> tail
            {
                tail := add(headStart, 32)
                mstore(headStart, and(value0, 0xffffffff))
            }
            function external_fun_moduleId()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPos := mload(64)
                mstore(memPos, and(/** @src 23:3116:3125  "_moduleId" */ loadimmutable("27677"), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff))
                return(memPos, 32)
            }
            function external_fun_countAndCall()
            {
                if callvalue() { revert(0, 0) }
                let value0 := /** @src -1:-1:-1 */ 0
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32)
                {
                    revert(/** @src -1:-1:-1 */ value0, value0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value := calldataload(4)
                validator_revert_address(value)
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:487:488  "2" */ 0x02)
                /// @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d"
                let _3 := 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3), /** @src 19:367:368  "1" */ 0x01))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let _4 := and(/** @src 58:5533:5553  "attacker_.callSender" */ value, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff)
                /// @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))"
                if iszero(extcodesize(_4))
                {
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    revert(/** @src -1:-1:-1 */ value0, value0)
                }
                /// @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))"
                let _5 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))"
                mstore(_5, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x0a2df1ed00000000000000000000000000000000000000000000000000000000)
                mstore(/** @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))" */ add(_5, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4), 0x083b273200000000000000000000000000000000000000000000000000000000)
                /// @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))"
                let _6 := call(gas(), _4, /** @src -1:-1:-1 */ value0, /** @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))" */ _5, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 36, /** @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))" */ _5, /** @src -1:-1:-1 */ value0)
                /// @src 58:5533:5586  "attacker_.callSender(bytes4(keccak256(\"callback()\")))"
                if iszero(_6) { revert_forward() }
                if _6
                {
                    finalize_allocation_9608(_5)
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    value0 := /** @src -1:-1:-1 */ value0
                }
                /// @src 23:1538:1601  "_REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED"
                update_storage_value_offsett_uint256_to_uint256()
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(value0, value0)
            }
            function external_fun_isReentrancyStatusLocked()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                /// @src 58:4627:4696  "return _REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED"
                let var := /** @src 58:4634:4696  "_REFLEX_STORAGE().reentrancyStatus == _REENTRANCY_GUARD_LOCKED" */ eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041), /** @src 19:487:488  "2" */ 0x02)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, var)
                return(memPos, 32)
            }
            function external_fun_endpointLog2Topic()
            {
                if callvalue() { revert(0, 0) }
                let _1 := abi_decode_bytes(calldatasize())
                /// @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ add(expr_mpos, 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x0200000000000000000000000000000000000000000000000000000000000000)
                mstore(add(/** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), /** @src 58:2848:2849  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                mstore(add(/** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65), /** @src 58:2828:2829  "2" */ 0x02)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let length := mload(_1)
                copy_memory_to_memory_with_cleanup(add(_1, /** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ 0x20), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97), length)
                /// @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)"
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ length), /** @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)" */ expr_mpos)
                mstore(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65))
                /// @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)"
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 97))
                /// @src 58:2805:2883  "abi.encodePacked(uint8(2), bytes32(uint256(1)), bytes32(uint256(2)), message_)"
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_revertPanicDivisionByZero()
            {
                if callvalue() { revert(0, 0) }
                let _1 := 0
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                /// @src 58:1726:1744  "new PanicThrower()"
                let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1726:1744  "new PanicThrower()"
                let _3 := datasize("PanicThrower_42197")
                let _4 := add(_2, _3)
                if or(gt(_4, 0xffffffffffffffff), lt(_4, _2)) { panic_error_0x41() }
                datacopy(_2, dataoffset("PanicThrower_42197"), _3)
                let expr_address := create(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, /** @src 58:1726:1744  "new PanicThrower()" */ _2, sub(_4, _2))
                if iszero(expr_address) { revert_forward() }
                /// @src 58:1801:1854  "abi.encodeWithSignature(\"throwPanicDivisionByZero()\")"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 58:1801:1854  "abi.encodeWithSignature(\"throwPanicDivisionByZero()\")"
                let _5 := add(expr_mpos, 0x20)
                mstore(_5, 0xd113c17600000000000000000000000000000000000000000000000000000000)
                mstore(expr_mpos, 4)
                finalize_allocation_9611(expr_mpos)
                /// @src 58:1779:1855  "address(thrower).call(abi.encodeWithSignature(\"throwPanicDivisionByZero()\"))"
                pop(call(gas(), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 58:1779:1795  "address(thrower)" */ expr_address, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff), _1, /** @src 58:1779:1855  "address(thrower).call(abi.encodeWithSignature(\"throwPanicDivisionByZero()\"))" */ _5, mload(expr_mpos), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, _1))
                /// @src 58:1879:1883  "data"
                fun_revertBytes(/** @src 58:1779:1855  "address(thrower).call(abi.encodeWithSignature(\"throwPanicDivisionByZero()\"))" */ extract_returndata())
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_moduleSettings()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let memPtr := mload(64)
                finalize_allocation_9611(memPtr)
                mstore(memPtr, 0)
                mstore(add(memPtr, 32), 0)
                let memPtr_1 := mload(64)
                finalize_allocation_9611(memPtr_1)
                let _1 := and(/** @src 23:3457:3466  "_moduleId" */ loadimmutable("27677"), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff)
                mstore(memPtr_1, _1)
                /// @src 23:3431:3493  "ModuleSettings({moduleId: _moduleId, moduleType: _moduleType})"
                let _2 := add(memPtr_1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32)
                let _3 := 0xffff
                mstore(_2, and(/** @src 23:3480:3491  "_moduleType" */ loadimmutable("27680"), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3))
                let memPos := mload(64)
                mstore(memPos, _1)
                mstore(add(memPos, 32), and(mload(_2), _3))
                return(memPos, 64)
            }
            function external_fun_performStaticCall()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 64)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value := calldataload(4)
                validator_revert_address(value)
                let offset := calldataload(36)
                if gt(offset, 0xffffffffffffffff)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value1 := abi_decode_bytes_memory_ptr(add(4, offset), calldatasize())
                /// @src 30:649:705  "if (contractAddress_ == address(0)) revert ZeroAddress()"
                if /** @src 30:653:683  "contractAddress_ == address(0)" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:653:683  "contractAddress_ == address(0)" */ value, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff))
                /// @src 30:649:705  "if (contractAddress_ == address(0)) revert ZeroAddress()"
                {
                    /// @src 30:692:705  "ZeroAddress()"
                    let _1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 30:692:705  "ZeroAddress()"
                    mstore(_1, 98233406313227496322093762137447883647064756579170498572149413615135132483584)
                    revert(_1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 30:754:792  "contractAddress_.staticcall(callData_)"
                let expr_component := staticcall(gas(), value, add(value1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32), /** @src 30:754:792  "contractAddress_.staticcall(callData_)" */ mload(value1), /** @src -1:-1:-1 */ 0, 0)
                /// @src 30:754:792  "contractAddress_.staticcall(callData_)"
                let expr_component_mpos := extract_returndata()
                /// @src 30:803:837  "if (!success) _revertBytes(result)"
                if /** @src 30:807:815  "!success" */ iszero(expr_component)
                /// @src 30:803:837  "if (!success) _revertBytes(result)"
                {
                    /// @src 30:830:836  "result"
                    fun_revertBytes(expr_component_mpos)
                }
                /// @src 30:848:919  "assembly {..."
                return(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32, /** @src 30:848:919  "assembly {..." */ expr_component_mpos), mload(expr_component_mpos))
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_getReentrancyStatus()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 0) { revert(0, 0) }
                let _1 := sload(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPos := mload(64)
                mstore(memPos, _1)
                return(memPos, 32)
            }
            function external_fun_countDirectRecursive()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value0 := calldataload(4)
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:487:488  "2" */ 0x02)
                /// @src 58:4888:5009  "if (n_ > 0) {..."
                if /** @src 58:4892:4898  "n_ > 0" */ iszero(iszero(value0))
                /// @src 58:4888:5009  "if (n_ > 0) {..."
                {
                    /// @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d"
                    let _3 := 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d
                    /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                    sstore(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3), /** @src 19:367:368  "1" */ 0x01))
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let diff := add(value0, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                    if gt(diff, value0)
                    {
                        mstore(/** @src 58:4897:4898  "0" */ 0x00, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                        mstore(4, 0x11)
                        revert(/** @src 58:4897:4898  "0" */ 0x00, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x24)
                    }
                    /// @src 58:4816:5015  "function countDirectRecursive(uint256 n_) public nonReentrant {..."
                    modifier_nonReentrant(diff)
                }
                /// @src 23:1538:1601  "_REFLEX_STORAGE().reentrancyStatus = _REENTRANCY_GUARD_UNLOCKED"
                update_storage_value_offsett_uint256_to_uint256()
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_revertBytes()
            {
                if callvalue() { revert(0, 0) }
                /// @src 58:7015:7028  "errorMessage_"
                fun_revertBytes(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ abi_decode_bytes(calldatasize()))
            }
            function external_fun_simulateBatchCallRevert()
            {
                if callvalue() { revert(0, 0) }
                let param, param_1 := abi_decode_array_struct_BatchAction_calldata_dyn_calldata(calldatasize())
                /// @src 30:1799:1821  "_unpackMessageSender()"
                let expr := /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ calldatasize(), /** @src 23:6185:6298  "assembly (\"memory-safe\") {..." */ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd8)))
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                let _1 := 1
                /// @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177"
                let _2 := 0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177" */ _2, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 54:609:675  "0x1341c5d22aaf5144e19b621a10c11ed727e6c461de3386254a323deb804b3177" */ _2), /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ _1))
                /// @src 30:1965:2007  "new BatchActionResponse[](actions_.length)"
                let expr_mpos := allocate_and_zero_memory_array_array_struct_BatchActionResponse_dyn(param_1)
                /// @src 30:2023:2036  "uint256 i = 0"
                let var_i := /** @src 30:2035:2036  "0" */ 0x00
                /// @src 30:2018:2370  "for (uint256 i = 0; i < actionsLength; ) {..."
                for { }
                /** @src 30:2038:2055  "i < actionsLength" */ lt(var_i, param_1)
                /// @src 30:2023:2036  "uint256 i = 0"
                { }
                {
                    /// @src 30:2167:2209  "_performBatchAction(messageSender, action)"
                    let expr_component, expr_component_mpos := fun_performBatchAction(expr, /** @src 30:2103:2114  "actions_[i]" */ calldata_array_index_access_struct_BatchAction_calldata_dyn_calldata(param, param_1, var_i))
                    /// @src 30:2240:2299  "BatchActionResponse({success: success, returnData: result})"
                    let expr_mpos_1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ allocate_memory()
                    /// @src 30:2240:2299  "BatchActionResponse({success: success, returnData: result})"
                    write_to_memory_bool(expr_mpos_1, expr_component)
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    mstore(/** @src 30:2240:2299  "BatchActionResponse({success: success, returnData: result})" */ add(expr_mpos_1, 32), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ expr_component_mpos)
                    /// @src 30:2224:2299  "simulation[i] = BatchActionResponse({success: success, returnData: result})"
                    mstore(memory_array_index_access_struct_BatchActionResponse_dyn(expr_mpos, var_i), expr_mpos_1)
                    pop(memory_array_index_access_struct_BatchActionResponse_dyn(expr_mpos, var_i))
                    /// @src 30:2342:2345  "++i"
                    var_i := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ add(/** @src 30:2342:2345  "++i" */ var_i, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ _1)
                }
                /// @ast-id 41176 @src 54:1686:1900  "function _afterBatchCall(address x_) internal override {..."
                /** @ast-id 41176 */ /** @ast-id 41176 */ fun_afterBatchCall()
                /// @src 30:2428:2455  "BatchSimulation(simulation)"
                let _3 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                /// @src 30:2428:2455  "BatchSimulation(simulation)"
                mstore(_3, 21297608865810698658712166479732360652793969106660705237887182076380696281088)
                revert(_3, sub(abi_encode_array_struct_BatchActionResponse_dyn(add(_3, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 4), /** @src 30:2428:2455  "BatchSimulation(simulation)" */ expr_mpos), _3))
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function external_fun_endpointLog1Topic()
            {
                if callvalue() { revert(0, 0) }
                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), 32)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let offset := calldataload(4)
                if gt(offset, 0xffffffffffffffff)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let value0, value1 := abi_decode_string_calldata(add(4, offset), calldatasize())
                /// @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)"
                let expr_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                mstore(/** @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)" */ add(expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 32), 0x0100000000000000000000000000000000000000000000000000000000000000)
                mstore(add(/** @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33), /** @src 58:2668:2669  "1" */ 0x01)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                calldatacopy(add(/** @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65), value0, value1)
                let _1 := add(/** @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)" */ expr_mpos, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ value1)
                mstore(add(_1, 65), /** @src -1:-1:-1 */ 0)
                /// @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)"
                let _2 := sub(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1, /** @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)" */ expr_mpos)
                mstore(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 33))
                /// @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)"
                finalize_allocation(expr_mpos, add(_2, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 65))
                /// @src 58:2645:2702  "abi.encodePacked(uint8(1), bytes32(uint256(1)), message_)"
                fun_issueLogToEndpoint(expr_mpos)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                return(/** @src -1:-1:-1 */ 0, 0)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function write_to_memory_uint32(memPtr, value)
            {
                mstore(memPtr, and(value, 0xffffffff))
            }
            function extract_returndata() -> data
            {
                switch returndatasize()
                case 0 { data := 96 }
                default {
                    let _1 := returndatasize()
                    let _2 := array_allocation_size_bytes(_1)
                    let memPtr := mload(64)
                    finalize_allocation(memPtr, _2)
                    mstore(memPtr, _1)
                    data := memPtr
                    returndatacopy(add(memPtr, 0x20), /** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ returndatasize())
                }
            }
            /// @ast-id 27966 @src 23:7521:7960  "function _revertBytes(bytes memory errorMessage_) internal pure virtual {..."
            function fun_revertBytes(var_errorMessage_mpos)
            {
                /// @src 23:7603:7954  "assembly (\"memory-safe\") {..."
                if iszero(mload(var_errorMessage_mpos))
                {
                    mstore(0x00, 0x4f3d7def)
                    revert(0x1c, 0x04)
                }
                revert(add(32, var_errorMessage_mpos), mload(var_errorMessage_mpos))
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function panic_error_0x32()
            {
                mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                mstore(4, 0x32)
                revert(0, 0x24)
            }
            function calldata_array_index_access_struct_BatchAction_calldata_dyn_calldata(base_ref, length, index) -> addr
            {
                if iszero(lt(index, length)) { panic_error_0x32() }
                let rel_offset_of_tail := calldataload(add(base_ref, shl(5, index)))
                if iszero(slt(rel_offset_of_tail, add(sub(calldatasize(), base_ref), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1)))
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                addr := add(base_ref, rel_offset_of_tail)
            }
            function validator_revert_bool(value)
            {
                if iszero(eq(value, iszero(iszero(value)))) { revert(0, 0) }
            }
            function array_allocation_size_array_struct_BatchActionResponse_dyn(length) -> size
            {
                if gt(length, 0xffffffffffffffff) { panic_error_0x41() }
                size := add(shl(5, length), 0x20)
            }
            function allocate_and_zero_memory_array_array_struct_BatchActionResponse_dyn(length) -> memPtr
            {
                let _1 := array_allocation_size_array_struct_BatchActionResponse_dyn(length)
                let _2 := 64
                let memPtr_1 := mload(_2)
                finalize_allocation(memPtr_1, _1)
                mstore(memPtr_1, length)
                memPtr := memPtr_1
                let _3 := add(array_allocation_size_array_struct_BatchActionResponse_dyn(length), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0)
                let i := /** @src -1:-1:-1 */ 0
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let i_1 := /** @src -1:-1:-1 */ i
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                for { } lt(i_1, _3) { i_1 := add(i_1, 32) }
                {
                    let memPtr_2 := mload(_2)
                    finalize_allocation_9611(memPtr_2)
                    mstore(memPtr_2, /** @src -1:-1:-1 */ i)
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let _4 := 32
                    mstore(add(memPtr_2, _4), 96)
                    mstore(add(add(memPtr_1, i_1), _4), memPtr_2)
                }
            }
            function write_to_memory_bool(memPtr, value)
            {
                mstore(memPtr, iszero(iszero(value)))
            }
            function memory_array_index_access_struct_BatchActionResponse_dyn(baseRef, index) -> addr
            {
                if iszero(lt(index, mload(baseRef))) { panic_error_0x32() }
                addr := add(add(baseRef, shl(5, index)), 32)
            }
            function mapping_index_access_mapping_uint32_address_of_uint32(key) -> dataSlot
            {
                mstore(0, and(key, 0xffffffff))
                mstore(0x20, /** @src 23:5726:5751  "_REFLEX_STORAGE().modules" */ 0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae0c)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                dataSlot := keccak256(0, 0x40)
            }
            function mapping_index_access_mapping_uint32_address_of_uint32_9646(key) -> dataSlot
            {
                mstore(0, and(key, 0xffffffff))
                mstore(0x20, /** @src 23:4247:4274  "_REFLEX_STORAGE().endpoints" */ 0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae0d)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                dataSlot := keccak256(0, 0x40)
            }
            function read_from_storage_split_offset_t_address(slot) -> value
            {
                value := and(sload(slot), 0xffffffffffffffffffffffffffffffffffffffff)
            }
            function abi_encode_bytes_calldata(start, length, pos) -> end
            {
                mstore(pos, length)
                calldatacopy(add(pos, 0x20), start, length)
                mstore(add(add(pos, length), 0x20), /** @src -1:-1:-1 */ 0)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                end := add(add(pos, and(add(length, 31), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0)), 0x20)
            }
            function abi_encode_array_struct_BatchAction_calldata_dyn_calldata(headStart, value0, value1) -> tail
            {
                let _1 := 32
                let tail_1 := add(headStart, _1)
                mstore(headStart, _1)
                let pos := tail_1
                mstore(tail_1, value1)
                let _2 := 64
                pos := add(headStart, _2)
                let tail_2 := add(add(headStart, shl(5, value1)), _2)
                let srcPtr := value0
                let i := 0
                for { } lt(i, value1) { i := add(i, 1) }
                {
                    mstore(pos, add(sub(tail_2, headStart), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc0))
                    let rel_offset_of_tail := calldataload(srcPtr)
                    if iszero(slt(rel_offset_of_tail, add(sub(calldatasize(), value0), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1))) { revert(0, 0) }
                    let value := add(rel_offset_of_tail, value0)
                    let _3 := 0x60
                    let value_1 := calldataload(value)
                    validator_revert_address(value_1)
                    mstore(tail_2, and(value_1, 0xffffffffffffffffffffffffffffffffffffffff))
                    let value_2 := calldataload(add(value, _1))
                    validator_revert_bool(value_2)
                    mstore(add(tail_2, _1), iszero(iszero(value_2)))
                    let rel_offset_of_tail_1 := calldataload(add(value, _2))
                    if iszero(slt(rel_offset_of_tail_1, add(sub(calldatasize(), value), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1))) { revert(0, 0) }
                    let value_3 := add(rel_offset_of_tail_1, value)
                    let length := calldataload(value_3)
                    let value_4 := add(value_3, _1)
                    if gt(length, 0xffffffffffffffff) { revert(0, 0) }
                    if sgt(value_4, sub(calldatasize(), length)) { revert(0, 0) }
                    mstore(add(tail_2, _2), _3)
                    tail_2 := abi_encode_bytes_calldata(value_4, length, add(tail_2, _3))
                    srcPtr := add(srcPtr, _1)
                    pos := add(pos, _1)
                }
                tail := tail_2
            }
            function abi_encode_packed_bytes_uint160_uint160(pos, value0, value1, value2) -> end
            {
                let length := mload(value0)
                copy_memory_to_memory_with_cleanup(add(value0, 0x20), pos, length)
                let end_1 := add(pos, length)
                let _1 := 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000
                mstore(end_1, and(shl(96, value1), _1))
                mstore(add(end_1, 20), and(shl(96, value2), _1))
                end := add(end_1, 40)
            }
            function convert_bytes_to_fixedbytes_from_bytes_to_bytes4(array) -> value
            {
                let length := mload(array)
                let _1 := mload(add(array, 0x20))
                let _2 := 0xffffffff00000000000000000000000000000000000000000000000000000000
                value := and(_1, _2)
                if lt(length, 4)
                {
                    value := and(and(_1, shl(shl(3, sub(4, length)), _2)), _2)
                }
            }
            function abi_decode_array_struct_BatchActionResponse_dyn_fromMemory(headStart, dataEnd) -> value0
            {
                let _1 := 32
                if slt(sub(dataEnd, headStart), _1) { revert(0, 0) }
                let offset := mload(headStart)
                let _2 := 0xffffffffffffffff
                if gt(offset, _2) { revert(0, 0) }
                let _3 := add(headStart, offset)
                if iszero(slt(add(_3, 0x1f), dataEnd))
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let _4 := mload(_3)
                let _5 := array_allocation_size_array_struct_BatchActionResponse_dyn(_4)
                let _6 := 64
                let memPtr := mload(_6)
                finalize_allocation(memPtr, _5)
                let dst := memPtr
                mstore(memPtr, _4)
                dst := add(memPtr, _1)
                let srcEnd := add(add(_3, shl(5, _4)), _1)
                if gt(srcEnd, dataEnd)
                {
                    revert(/** @src -1:-1:-1 */ 0, 0)
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let src := add(_3, _1)
                for { } lt(src, srcEnd) { src := add(src, _1) }
                {
                    let innerOffset := mload(src)
                    if gt(innerOffset, _2)
                    {
                        /// @src -1:-1:-1
                        let _7 := 0
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        revert(/** @src -1:-1:-1 */ _7, _7)
                    }
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let _8 := add(_3, innerOffset)
                    if slt(add(sub(dataEnd, _8), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0), _6)
                    {
                        /// @src -1:-1:-1
                        let _9 := 0
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        revert(/** @src -1:-1:-1 */ _9, _9)
                    }
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let memPtr_1 := mload(_6)
                    finalize_allocation_9611(memPtr_1)
                    let value := mload(add(_8, _1))
                    validator_revert_bool(value)
                    mstore(memPtr_1, value)
                    let offset_1 := mload(add(_8, _6))
                    if gt(offset_1, _2)
                    {
                        /// @src -1:-1:-1
                        let _10 := 0
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        revert(/** @src -1:-1:-1 */ _10, _10)
                    }
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let _11 := add(_8, offset_1)
                    if iszero(slt(add(_11, 63), dataEnd))
                    {
                        /// @src -1:-1:-1
                        let _12 := 0
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        revert(/** @src -1:-1:-1 */ _12, _12)
                    }
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let _13 := mload(add(_11, _1))
                    let _14 := array_allocation_size_bytes(_13)
                    let memPtr_2 := mload(_6)
                    finalize_allocation(memPtr_2, _14)
                    mstore(memPtr_2, _13)
                    if gt(add(add(_11, _13), _6), dataEnd)
                    {
                        /// @src -1:-1:-1
                        let _15 := 0
                        /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                        revert(/** @src -1:-1:-1 */ _15, _15)
                    }
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    copy_memory_to_memory_with_cleanup(add(_11, _6), add(memPtr_2, _1), _13)
                    mstore(add(memPtr_1, _1), memPtr_2)
                    mstore(dst, memPtr_1)
                    dst := add(dst, _1)
                }
                value0 := memPtr
            }
            function read_from_calldatat_address(ptr) -> returnValue
            {
                let value := calldataload(ptr)
                validator_revert_address(value)
                returnValue := value
            }
            function mapping_index_access_mapping_address_struct_TrustRelation_storage_of_address(key) -> dataSlot
            {
                mstore(0, and(key, 0xffffffffffffffffffffffffffffffffffffffff))
                mstore(0x20, /** @src 30:5525:5552  "_REFLEX_STORAGE().relations" */ 0x9ae9f1beea1ab16fc6eb61501e697d7f95dba720bc92d8f5c0ec2c2a99f1ae0e)
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                dataSlot := keccak256(0, 0x40)
            }
            function read_from_storage_split_offset_uint32(slot) -> value
            {
                value := and(sload(slot), 0xffffffff)
            }
            function read_from_storage_split_offset_address(slot) -> value
            {
                value := and(shr(32, sload(slot)), 0xffffffffffffffffffffffffffffffffffffffff)
            }
            function access_calldata_tail_bytes_calldata(base_ref, ptr_to_tail) -> addr, length
            {
                let rel_offset_of_tail := calldataload(ptr_to_tail)
                if iszero(slt(rel_offset_of_tail, add(sub(calldatasize(), base_ref), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1))) { revert(0, 0) }
                let addr_1 := add(base_ref, rel_offset_of_tail)
                length := calldataload(addr_1)
                if gt(length, 0xffffffffffffffff) { revert(0, 0) }
                addr := add(addr_1, 0x20)
                if sgt(addr, sub(calldatasize(), length)) { revert(0, 0) }
            }
            function abi_encode_packed_bytes_calldata_uint160_uint160(pos, value0, value1, value2, value3) -> end
            {
                calldatacopy(pos, value0, value1)
                let _1 := add(pos, value1)
                let _2 := 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000
                mstore(_1, and(shl(96, value2), _2))
                mstore(add(_1, 20), and(shl(96, value3), _2))
                end := add(_1, 40)
            }
            /// @ast-id 28701 @src 30:4246:6133  "function _performBatchAction(..."
            function fun_performBatchAction(var_messageSender, var_action_offset) -> var_success, var_returnData_mpos
            {
                /// @src 30:4493:4516  "action_.endpointAddress"
                let expr := read_from_calldatat_address(var_action_offset)
                /// @src 30:5525:5578  "_REFLEX_STORAGE().relations[endpointAddress].moduleId"
                let _1 := read_from_storage_split_offset_uint32(/** @src 30:5525:5569  "_REFLEX_STORAGE().relations[endpointAddress]" */ mapping_index_access_mapping_address_struct_TrustRelation_storage_of_address(expr))
                /// @src 30:5589:5642  "if (moduleId_ == 0) revert ModuleIdInvalid(moduleId_)"
                if /** @src 30:5593:5607  "moduleId_ == 0" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:5593:5607  "moduleId_ == 0" */ _1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff))
                /// @src 30:5589:5642  "if (moduleId_ == 0) revert ModuleIdInvalid(moduleId_)"
                {
                    /// @src 30:5616:5642  "ModuleIdInvalid(moduleId_)"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 30:5616:5642  "ModuleIdInvalid(moduleId_)"
                    mstore(_2, 5993566304175327204638858231961608678278686243123690744609498110969438535680)
                    revert(_2, sub(abi_encode_uint32(add(_2, 4), _1), _2))
                }
                /// @src 30:5653:5749  "address moduleImplementation = _REFLEX_STORAGE().relations[endpointAddress].moduleImplementation"
                let var_moduleImplementation := /** @src 30:5684:5749  "_REFLEX_STORAGE().relations[endpointAddress].moduleImplementation" */ read_from_storage_split_offset_address(/** @src 30:5684:5728  "_REFLEX_STORAGE().relations[endpointAddress]" */ mapping_index_access_mapping_address_struct_TrustRelation_storage_of_address(expr))
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let _3 := 0xffffffffffffffffffffffffffffffffffffffff
                /// @src 30:5760:5859  "if (moduleImplementation == address(0)) moduleImplementation = _REFLEX_STORAGE().modules[moduleId_]"
                if /** @src 30:5764:5798  "moduleImplementation == address(0)" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:5764:5798  "moduleImplementation == address(0)" */ var_moduleImplementation, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3))
                /// @src 30:5760:5859  "if (moduleImplementation == address(0)) moduleImplementation = _REFLEX_STORAGE().modules[moduleId_]"
                {
                    /// @src 30:5800:5859  "moduleImplementation = _REFLEX_STORAGE().modules[moduleId_]"
                    var_moduleImplementation := /** @src 30:5823:5859  "_REFLEX_STORAGE().modules[moduleId_]" */ read_from_storage_split_offset_t_address(mapping_index_access_mapping_uint32_address_of_uint32(_1))
                }
                /// @src 30:5870:5947  "if (moduleImplementation == address(0)) revert ModuleNotRegistered(moduleId_)"
                if /** @src 30:5874:5908  "moduleImplementation == address(0)" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:5874:5908  "moduleImplementation == address(0)" */ var_moduleImplementation, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3))
                /// @src 30:5870:5947  "if (moduleImplementation == address(0)) revert ModuleNotRegistered(moduleId_)"
                {
                    /// @src 30:5917:5947  "ModuleNotRegistered(moduleId_)"
                    let _4 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 30:5917:5947  "ModuleNotRegistered(moduleId_)"
                    mstore(_4, 78910954071871934808072200951907275086069747012232091378474079809210566049792)
                    revert(_4, sub(abi_encode_uint32(add(_4, 4), _1), _4))
                }
                /// @src 30:6048:6064  "action_.callData"
                let expr_offset, expr_length := access_calldata_tail_bytes_calldata(var_action_offset, add(var_action_offset, 64))
                /// @src 30:6031:6116  "abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))"
                let expr_28696_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(/** @src 30:6048:6064  "action_.callData" */ 64)
                /// @src 30:6031:6116  "abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))"
                let _5 := add(expr_28696_mpos, 0x20)
                let _6 := sub(abi_encode_packed_bytes_calldata_uint160_uint160(_5, expr_offset, expr_length, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 30:6066:6089  "uint160(messageSender_)" */ var_messageSender, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3), and(/** @src 30:6091:6115  "uint160(endpointAddress)" */ expr, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _3)), /** @src 30:6031:6116  "abi.encodePacked(action_.callData, uint160(messageSender_), uint160(endpointAddress))" */ expr_28696_mpos)
                mstore(expr_28696_mpos, add(_6, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0))
                finalize_allocation(expr_28696_mpos, _6)
                /// @src 30:5984:6126  "moduleImplementation.delegatecall(..."
                let expr_28697_component := delegatecall(gas(), var_moduleImplementation, _5, mload(expr_28696_mpos), /** @src 30:4493:4516  "action_.endpointAddress" */ 0, 0)
                /// @src 30:5958:6126  "(success_, returnData_) = moduleImplementation.delegatecall(..."
                var_returnData_mpos := /** @src 30:5984:6126  "moduleImplementation.delegatecall(..." */ extract_returndata()
                /// @src 30:5958:6126  "(success_, returnData_) = moduleImplementation.delegatecall(..."
                var_success := expr_28697_component
            }
            /// @ast-id 41176 @src 54:1686:1900  "function _afterBatchCall(address x_) internal override {..."
            function fun_afterBatchCall()
            {
                /// @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64"
                let _1 := 0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64
                /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                sstore(/** @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64" */ _1, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 54:845:911  "0x275df4c7315c3d7a3ff703ad0c15eafa230b4ec1a5793f54ae5d2e4586513a64" */ _1), /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ 1))
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function revert_forward()
            {
                let pos := mload(64)
                returndatacopy(pos, 0, returndatasize())
                revert(pos, returndatasize())
            }
            /// @src 19:367:368  "1"
            function update_storage_value_offsett_uint256_to_uint256()
            {
                sstore(/** @src 24:3714:3784  "assembly {..." */ 70069522515829887802513748556466771436924110247908523946892624562668623212041, /** @src 19:367:368  "1" */ 0x01)
            }
            /// @ast-id 27711 @src 23:1075:1608  "modifier nonReentrant() virtual {..."
            function modifier_nonReentrant(var_n)
            {
                /// @src 24:3714:3784  "assembly {..."
                let _1 := 70069522515829887802513748556466771436924110247908523946892624562668623212041
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                if /** @src 23:1215:1279  "_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED" */ iszero(eq(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ sload(/** @src 24:3714:3784  "assembly {..." */ _1), /** @src 19:367:368  "1" */ 0x01))
                /// @src 23:1211:1300  "if (_REFLEX_STORAGE().reentrancyStatus != _REENTRANCY_GUARD_UNLOCKED) revert Reentrancy()"
                {
                    /// @src 23:1288:1300  "Reentrancy()"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:1288:1300  "Reentrancy()"
                    mstore(_2, 77381248315574607535161182195890686462825415855925804648330609829886665162752)
                    revert(_2, 4)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:487:488  "2" */ 0x02)
                /// @src 58:4888:5009  "if (n_ > 0) {..."
                if /** @src 58:4892:4898  "n_ > 0" */ iszero(iszero(var_n))
                /// @src 58:4888:5009  "if (n_ > 0) {..."
                {
                    /// @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d"
                    let _3 := 0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d
                    /// @src 58:7314:7398  "assembly (\"memory-safe\") {..."
                    sstore(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3, /** @src 58:7314:7398  "assembly (\"memory-safe\") {..." */ add(sload(/** @src 58:511:577  "0x5f809fe156313a375467a4992bdaab633eaa036b3c3ff04934ffb3aba7d3cc9d" */ _3), /** @src 19:367:368  "1" */ 0x01))
                    /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                    let diff := add(var_n, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
                    if gt(diff, var_n)
                    {
                        mstore(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                        mstore(4, 0x11)
                        revert(/** @src -1:-1:-1 */ 0, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0x24)
                    }
                    /// @src 58:4816:5015  "function countDirectRecursive(uint256 n_) public nonReentrant {..."
                    modifier_nonReentrant(/** @src 58:4991:4997  "n_ - 1" */ diff)
                }
                /// @src 19:367:368  "1"
                sstore(/** @src 24:3714:3784  "assembly {..." */ _1, /** @src 19:367:368  "1" */ 0x01)
            }
            /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
            function assert_helper(condition)
            {
                if iszero(condition)
                {
                    mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                    mstore(4, 0x01)
                    revert(0, 0x24)
                }
            }
            /// @src 19:878:879  "2"
            function update_storage_value_offsett_address_to_address(slot, value)
            {
                sstore(slot, or(and(sload(slot), 0xffffffffffffffffffffffff0000000000000000000000000000000000000000), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 19:878:879  "2" */ value, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff)))
            }
            /// @src 19:878:879  "2"
            function write_to_memory_address(memPtr, value)
            {
                mstore(memPtr, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 19:878:879  "2" */ value, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffffffffffffffffffffffffffffffffffff))
            }
            /// @src 19:878:879  "2"
            function copy_struct_to_storage_from_struct_TrustRelation_to_struct_TrustRelation(slot, value)
            {
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let cleaned := and(/** @src 19:878:879  "2" */ mload(value), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff)
                /// @src 19:878:879  "2"
                let _1 := sload(slot)
                sstore(slot, or(and(_1, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000), cleaned))
                sstore(slot, or(or(and(_1, 0xffffffffffffffff000000000000000000000000000000000000000000000000), cleaned), and(shl(32, mload(add(value, 32))), 0xffffffffffffffffffffffffffffffffffffffff00000000)))
            }
            /// @ast-id 27899 @src 23:3839:5271  "function _createEndpoint(..."
            function fun_createEndpoint(var_moduleId, var_moduleType, var_moduleImplementation_) -> var_endpointAddress
            {
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let _1 := and(/** @src 23:4029:4043  "moduleId_ == 0" */ var_moduleId, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffffffff)
                /// @src 23:4025:4078  "if (moduleId_ == 0) revert ModuleIdInvalid(moduleId_)"
                if /** @src 23:4029:4043  "moduleId_ == 0" */ iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _1)
                /// @src 23:4025:4078  "if (moduleId_ == 0) revert ModuleIdInvalid(moduleId_)"
                {
                    /// @src 23:4052:4078  "ModuleIdInvalid(moduleId_)"
                    let _2 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:4052:4078  "ModuleIdInvalid(moduleId_)"
                    mstore(_2, 5993566304175327204638858231961608678278686243123690744609498110969438535680)
                    revert(_2, sub(abi_encode_uint32(add(_2, 4), var_moduleId), _2))
                }
                /// @src 23:4092:4135  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT"
                let _3 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 23:4092:4135  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT" */ var_moduleType, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ 0xffff)
                /// @src 23:4092:4135  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT"
                let _4 := eq(_3, /** @src 19:713:714  "1" */ 0x01)
                /// @src 23:4092:4181  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT && moduleType_ != _MODULE_TYPE_MULTI_ENDPOINT"
                let expr := /** @src 23:4092:4135  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT" */ iszero(_4)
                /// @src 23:4092:4181  "moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT && moduleType_ != _MODULE_TYPE_MULTI_ENDPOINT"
                if expr
                {
                    expr := /** @src 23:4139:4181  "moduleType_ != _MODULE_TYPE_MULTI_ENDPOINT" */ iszero(eq(_3, /** @src 19:878:879  "2" */ 0x02))
                }
                /// @src 23:4088:4232  "if (moduleType_ != _MODULE_TYPE_SINGLE_ENDPOINT && moduleType_ != _MODULE_TYPE_MULTI_ENDPOINT)..."
                if expr
                {
                    /// @src 23:4202:4232  "ModuleTypeInvalid(moduleType_)"
                    let _5 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 23:4202:4232  "ModuleTypeInvalid(moduleType_)"
                    mstore(_5, 108820834782988330523768258442780543476035735081357127802864850937272915197952)
                    revert(_5, sub(abi_encode_uint16(add(_5, 4), var_moduleType), _5))
                }
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let _6 := 0xffffffffffffffffffffffffffffffffffffffff
                /// @src 23:4243:4346  "if (_REFLEX_STORAGE().endpoints[moduleId_] != address(0)) return _REFLEX_STORAGE().endpoints[moduleId_]"
                if /** @src 23:4247:4299  "_REFLEX_STORAGE().endpoints[moduleId_] != address(0)" */ iszero(iszero(/** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 23:4247:4285  "_REFLEX_STORAGE().endpoints[moduleId_]" */ read_from_storage_split_offset_t_address(mapping_index_access_mapping_uint32_address_of_uint32_9646(var_moduleId)), /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _6)))
                /// @src 23:4243:4346  "if (_REFLEX_STORAGE().endpoints[moduleId_] != address(0)) return _REFLEX_STORAGE().endpoints[moduleId_]"
                {
                    /// @src 23:4301:4346  "return _REFLEX_STORAGE().endpoints[moduleId_]"
                    var_endpointAddress := /** @src 23:4308:4346  "_REFLEX_STORAGE().endpoints[moduleId_]" */ read_from_storage_split_offset_t_address(mapping_index_access_mapping_uint32_address_of_uint32_9646(var_moduleId))
                    /// @src 23:4301:4346  "return _REFLEX_STORAGE().endpoints[moduleId_]"
                    leave
                }
                /// @src 23:4393:4428  "_getEndpointCreationCode(moduleId_)"
                let expr_27867_mpos := /** @ast-id 27982 @src 23:8566:8744  "function _getEndpointCreationCode(uint32) internal virtual returns (bytes memory endpointCreationCode_) {..." */ /** @ast-id 27982 */ fun_getEndpointCreationCode()
                /// @src 23:4439:4914  "assembly (\"memory-safe\") {..."
                var_endpointAddress := create(/** @src 23:4042:4043  "0" */ 0x00, /** @src 23:4439:4914  "assembly (\"memory-safe\") {..." */ add(expr_27867_mpos, 0x20), mload(expr_27867_mpos))
                if iszero(extcodesize(var_endpointAddress))
                {
                    mstore(/** @src 23:4042:4043  "0" */ 0x00, /** @src 23:4439:4914  "assembly (\"memory-safe\") {..." */ 0x0b3b0bd1)
                    revert(0x1c, /** @src 23:4247:4274  "_REFLEX_STORAGE().endpoints" */ 4)
                }
                /// @src 23:4924:5030  "if (moduleType_ == _MODULE_TYPE_SINGLE_ENDPOINT) _REFLEX_STORAGE().endpoints[moduleId_] = endpointAddress_"
                if _4
                {
                    /// @src 23:4973:5030  "_REFLEX_STORAGE().endpoints[moduleId_] = endpointAddress_"
                    update_storage_value_offsett_address_to_address(/** @src 23:4973:5011  "_REFLEX_STORAGE().endpoints[moduleId_]" */ mapping_index_access_mapping_uint32_address_of_uint32_9646(var_moduleId), /** @src 23:4973:5030  "_REFLEX_STORAGE().endpoints[moduleId_] = endpointAddress_" */ var_endpointAddress)
                }
                /// @src 23:5089:5204  "TrustRelation({..."
                let expr_27890_mpos := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ allocate_memory()
                /// @src 23:5089:5204  "TrustRelation({..."
                write_to_memory_uint32(expr_27890_mpos, var_moduleId)
                write_to_memory_address(add(expr_27890_mpos, /** @src 23:4439:4914  "assembly (\"memory-safe\") {..." */ 0x20), /** @src 23:5089:5204  "TrustRelation({..." */ var_moduleImplementation_)
                /// @src 19:878:879  "2"
                copy_struct_to_storage_from_struct_TrustRelation_to_struct_TrustRelation(/** @src 23:5041:5086  "_REFLEX_STORAGE().relations[endpointAddress_]" */ mapping_index_access_mapping_address_struct_TrustRelation_storage_of_address(var_endpointAddress), /** @src 19:878:879  "2" */ expr_27890_mpos)
                /// @src 23:5220:5264  "EndpointCreated(moduleId_, endpointAddress_)"
                log3(/** @src 23:4042:4043  "0" */ 0x00, 0x00, /** @src 23:5220:5264  "EndpointCreated(moduleId_, endpointAddress_)" */ 0x8dd261664f85c82715795749a2b9aef7eae2b0f7a99d11e67182e77cb1e1dd10, _1, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ and(/** @src 23:5220:5264  "EndpointCreated(moduleId_, endpointAddress_)" */ var_endpointAddress, /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ _6))
            }
            /// @ast-id 27982 @src 23:8566:8744  "function _getEndpointCreationCode(uint32) internal virtual returns (bytes memory endpointCreationCode_) {..."
            function fun_getEndpointCreationCode() -> var_endpointCreationCode_mpos
            {
                /// @src 23:8704:8737  "type(ReflexEndpoint).creationCode"
                let _1 := datasize("ReflexEndpoint_27281")
                /// @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..."
                let memPtr := mload(64)
                finalize_allocation(memPtr, /** @src 23:8704:8737  "type(ReflexEndpoint).creationCode" */ add(_1, 32))
                mstore(memPtr, _1)
                datacopy(add(memPtr, 32), dataoffset("ReflexEndpoint_27281"), _1)
                /// @src 23:8680:8737  "endpointCreationCode_ = type(ReflexEndpoint).creationCode"
                var_endpointCreationCode_mpos := memPtr
            }
            /// @ast-id 42112 @src 58:7410:7665  "function _issueLogToEndpoint(bytes memory payload) internal {..."
            function fun_issueLogToEndpoint(var_payload_mpos)
            {
                /// @src 58:7560:7589  "endpointAddress.call(payload)"
                let expr_42102_component := call(gas(), /** @src 23:6640:6755  "assembly (\"memory-safe\") {..." */ shr(96, calldataload(add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec))), /** @src 58:7560:7589  "endpointAddress.call(payload)" */ 0, add(var_payload_mpos, 0x20), mload(var_payload_mpos), 0, 0)
                pop(extract_returndata())
                /// @src 58:7600:7659  "if (!success) {..."
                if /** @src 58:7604:7612  "!success" */ iszero(expr_42102_component)
                /// @src 58:7600:7659  "if (!success) {..."
                {
                    /// @src 58:7635:7648  "FailedToLog()"
                    let _1 := /** @src 54:321:1902  "contract MockReflexBatch is MockHarness, ReflexBatch, MockReflexModule {..." */ mload(64)
                    /// @src 58:7635:7648  "FailedToLog()"
                    mstore(_1, 9078123898225366495210177562306750874689263393082056247661013028968889057280)
                    revert(_1, 4)
                }
            }
        }
        /// @use-src 21:"src/ReflexEndpoint.sol", 26:"src/interfaces/IReflexEndpoint.sol"
        object "ReflexEndpoint_27281" {
            code {
                {
                    /// @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..."
                    let _1 := memoryguard(0xa0)
                    mstore(64, _1)
                    if callvalue() { revert(0, 0) }
                    /// @src 21:592:614  "_deployer = msg.sender"
                    mstore(128, /** @src 21:604:614  "msg.sender" */ caller())
                    /// @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..."
                    let _2 := datasize("ReflexEndpoint_27281_deployed")
                    codecopy(_1, dataoffset("ReflexEndpoint_27281_deployed"), _2)
                    setimmutable(_1, "27253", mload(/** @src 21:592:614  "_deployer = msg.sender" */ 128))
                    /// @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..."
                    return(_1, _2)
                }
            }
            /// @use-src 21:"src/ReflexEndpoint.sol"
            object "ReflexEndpoint_27281_deployed" {
                code {
                    {
                        /// @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..."
                        mstore(64, 128)
                        if callvalue() { revert(0, 0) }
                        /// @src 21:1006:1015  "_deployer"
                        let _1 := loadimmutable("27253")
                        /// @src 21:1111:4765  "if (msg.sender == deployer_) {..."
                        switch /** @src 21:1115:1138  "msg.sender == deployer_" */ eq(/** @src 21:1115:1125  "msg.sender" */ caller(), /** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ and(/** @src 21:1115:1138  "msg.sender == deployer_" */ _1, /** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 0xffffffffffffffffffffffffffffffffffffffff))
                        case /** @src 21:1111:4765  "if (msg.sender == deployer_) {..." */ 0 {
                            /// @src 21:3558:4755  "assembly {..."
                            let _2 := 0x00
                            calldatacopy(_2, _2, calldatasize())
                            mstore(calldatasize(), shl(96, /** @src 21:1115:1125  "msg.sender" */ caller()))
                            /// @src 21:3558:4755  "assembly {..."
                            let usr$result := call(gas(), _1, _2, _2, add(calldatasize(), 20), _2, _2)
                            returndatacopy(_2, _2, returndatasize())
                            switch usr$result
                            case 0 { revert(_2, returndatasize()) }
                            default { return(_2, returndatasize()) }
                        }
                        default /// @src 21:1111:4765  "if (msg.sender == deployer_) {..."
                        {
                            /// @src 21:1268:3482  "assembly {..."
                            let _3 := 0x00
                            mstore(_3, _3)
                            calldatacopy(0x1F, _3, calldatasize())
                            switch mload(_3)
                            case 0 {
                                log0(0x20, add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff))
                            }
                            case 1 {
                                log1(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 64, /** @src 21:1268:3482  "assembly {..." */ add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdf), mload(0x20))
                            }
                            case 2 {
                                log2(0x60, add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffbf), mload(0x20), mload(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 64))
                            }
                            case /** @src 21:1268:3482  "assembly {..." */ 3 {
                                log3(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 128, /** @src 21:1268:3482  "assembly {..." */ add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff9f), mload(0x20), mload(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 64), /** @src 21:1268:3482  "assembly {..." */ mload(0x60))
                            }
                            case 4 {
                                log4(0xA0, add(calldatasize(), 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7f), mload(0x20), mload(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 64), /** @src 21:1268:3482  "assembly {..." */ mload(0x60), mload(/** @src 21:317:4773  "contract ReflexEndpoint is IReflexEndpoint {..." */ 128))
                            }
                            default /// @src 21:1268:3482  "assembly {..."
                            { revert(_3, _3) }
                            return(_3, _3)
                        }
                    }
                }
                data ".metadata" hex"a2646970667358221220de3c18e6ec625a683c7292ae99f1f5fc038251d383156483fd96563887b965bc64736f6c63430008130033"
            }
        }
        /// @use-src 58:"test/mocks/MockReflexModule.sol"
        object "CustomErrorThrower_42142" {
            code {
                {
                    /// @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..."
                    let _1 := memoryguard(0x80)
                    mstore(64, _1)
                    if callvalue() { revert(0, 0) }
                    let _2 := datasize("CustomErrorThrower_42142_deployed")
                    codecopy(_1, dataoffset("CustomErrorThrower_42142_deployed"), _2)
                    return(_1, _2)
                }
            }
            /// @use-src 58:"test/mocks/MockReflexModule.sol"
            object "CustomErrorThrower_42142_deployed" {
                code {
                    {
                        /// @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..."
                        let _1 := memoryguard(0x80)
                        let _2 := 4
                        if iszero(lt(calldatasize(), _2))
                        {
                            let _3 := 0
                            if eq(0x60d2c0d5, shr(224, calldataload(_3)))
                            {
                                if callvalue() { revert(_3, _3) }
                                let _4 := 64
                                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _4) { revert(_3, _3) }
                                let _5 := 36
                                let offset := calldataload(_5)
                                let _6 := 0xffffffffffffffff
                                if gt(offset, _6) { revert(_3, _3) }
                                if iszero(slt(add(offset, 35), calldatasize())) { revert(_3, _3) }
                                let length := calldataload(add(_2, offset))
                                if gt(length, _6) { revert(_3, _3) }
                                if gt(add(add(offset, length), _5), calldatasize()) { revert(_3, _3) }
                                let newFreePtr := add(_1, _4)
                                if or(gt(newFreePtr, _6), lt(newFreePtr, _1))
                                {
                                    mstore(_3, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                    mstore(_2, 0x41)
                                    revert(_3, _5)
                                }
                                mstore(_4, newFreePtr)
                                mstore(_1, calldataload(_2))
                                let _7 := 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0
                                let memPtr := mload(_4)
                                let newFreePtr_1 := add(memPtr, and(add(and(add(length, 0x1f), _7), 63), _7))
                                if or(gt(newFreePtr_1, _6), lt(newFreePtr_1, memPtr))
                                {
                                    mstore(_3, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                    mstore(_2, 0x41)
                                    revert(_3, _5)
                                }
                                mstore(_4, newFreePtr_1)
                                mstore(memPtr, length)
                                let _8 := 32
                                calldatacopy(add(memPtr, _8), add(offset, _5), length)
                                mstore(add(add(memPtr, length), _8), _3)
                                /// @src 58:8031:8081  "CustomErrorPayload({code: code, message: message})"
                                let _9 := add(_1, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ _8)
                                mstore(_9, memPtr)
                                /// @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))"
                                let _10 := /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ mload(_4)
                                /// @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))"
                                mstore(_10, 74855243796180728477532197697411681967453725595842026133776764182115293069312)
                                /// @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..."
                                mstore(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ add(_10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ _2), _8)
                                mstore(add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ _5), mload(_1))
                                let memberValue0 := mload(_9)
                                mstore(add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ 68), _4)
                                let length_1 := mload(memberValue0)
                                mstore(add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ 100), length_1)
                                let i := _3
                                for { } lt(i, length_1) { i := add(i, _8) }
                                {
                                    mstore(add(add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ i), 132), mload(add(add(memberValue0, i), _8)))
                                }
                                mstore(add(add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ length_1), 132), _3)
                                /// @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))"
                                revert(_10, add(sub(/** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ add(/** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10, /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ and(add(length_1, 0x1f), _7)), /** @src 58:8019:8082  "CustomError(CustomErrorPayload({code: code, message: message}))" */ _10), /** @src 58:7873:8091  "contract CustomErrorThrower is ICustomError {..." */ 132))
                            }
                        }
                        revert(0, 0)
                    }
                }
                data ".metadata" hex"a2646970667358221220d7919a012c376251ba37ef9756702279aa62ff675bd3773b00379c1e6a83c1e764736f6c63430008130033"
            }
        }
        /// @use-src 58:"test/mocks/MockReflexModule.sol"
        object "PanicThrower_42197" {
            code {
                {
                    /// @src 58:8093:8585  "contract PanicThrower {..."
                    let _1 := memoryguard(0x80)
                    mstore(64, _1)
                    if callvalue() { revert(0, 0) }
                    let _2 := datasize("PanicThrower_42197_deployed")
                    codecopy(_1, dataoffset("PanicThrower_42197_deployed"), _2)
                    return(_1, _2)
                }
            }
            /// @use-src 58:"test/mocks/MockReflexModule.sol"
            object "PanicThrower_42197_deployed" {
                code {
                    {
                        /// @src 58:8093:8585  "contract PanicThrower {..."
                        if iszero(lt(calldatasize(), 4))
                        {
                            let _1 := 0
                            switch shr(224, calldataload(_1))
                            case 0x0643cd05 {
                                if callvalue() { revert(_1, _1) }
                                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                                mstore(_1, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                mstore(4, 0x11)
                                revert(_1, 0x24)
                            }
                            case 0x6601d576 {
                                if callvalue() { revert(_1, _1) }
                                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                                mstore(_1, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                mstore(4, 1)
                                revert(_1, 0x24)
                            }
                            case 0xd113c176 {
                                if callvalue() { revert(_1, _1) }
                                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                                mstore(_1, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                mstore(4, 0x12)
                                revert(_1, 0x24)
                            }
                            case 0xed24c55a {
                                if callvalue() { revert(_1, _1) }
                                if slt(add(calldatasize(), 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc), _1) { revert(_1, _1) }
                                mstore(_1, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
                                mstore(4, 0x11)
                                revert(_1, 0x24)
                            }
                        }
                        revert(0, 0)
                    }
                }
                data ".metadata" hex"a264697066735822122021b374f64401873b8a87438f7eacb90700d3e8e7bc5b46e5bbaa84a151d706ab64736f6c63430008130033"
            }
        }
        data ".metadata" hex"a2646970667358221220ab8cdc7ef1325d7c69adc591c18f073ced1bcc1bb465337435d59233f2e71ae564736f6c63430008130033"
    }
}

