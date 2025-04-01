// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Proxy {
    address implementation;

    function upgrade(address _newImplementation) public {
        implementation = _newImplementation;
    }

    fallback() external {
        assembly {
            let ptr := mload(0x40)

            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(
                gas(),
                sload(implementation.slot),
                ptr,
                calldatasize(),
                0,
                0
            )

            returndatacopy(ptr, 0, returndatasize())

            switch result
            case 0 {
                revert(ptr, returndatasize())
            }
            default {
                return(ptr, returndatasize())
            }
        }
    }
}
