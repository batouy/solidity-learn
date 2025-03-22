// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * Immutable variables are like constants. Values of immutable variables can be set inside the constructor but cannot be modified afterwards.
 */
contract Immutable {
    address public immutable myAddress;
    uint256 public immutable myUnit;

    constructor(uint256 _num){
        myAddress = msg.sender;
        myUnit = _num;
    }
}
