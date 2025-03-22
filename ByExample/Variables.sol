// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * local: 1. declared inside a function; 2. not stored on the blockchain;
 * state: 1. declared outside a function; 2. stored on the blockchain;
 * global: provides information about the blockchain;
 */
contract Variables {
    // State variables
    string public text = "Hello";
    uint256 public num = 123;

    function doSomething() public view {
        // Local variable are not saved to the blockchain
        uint256 i = 323;

        // some global variable
        uint256 timestamp = block.timestamp;
        address sender = msg.sender;
    }
}
