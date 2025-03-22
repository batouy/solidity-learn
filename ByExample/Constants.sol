// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * Constants are variables that cannot be modified. Their value is hard coded and using constants can save gas cost.
 */
contract Constants {
    address public constant MYADDR = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint256 public constant MY_UNIT = 123;
}
