// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract InlineExample {
    function add(uint256 x, uint256 y) public pure returns (uint256 result) {
        assembly {
            result := add(x, y)
        }
    }

    function storeValue(uint256 slot, uint256 value) public {
        assembly {
            sstore(slot, value)
        }
    }

    function loadValue(uint256 slot) public view returns (uint256 result) {
        assembly {
            result := sload(slot)
        }
    }
}
