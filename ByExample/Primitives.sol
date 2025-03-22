// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Primitives {
    bool public boo = true;

    uint8 public u8 = 1;
    uint256 public u256 = 456;
    uint256 public u = 123; // uint is an alias for uint256

    int8 public i8 = -1;
    int256 public i256 = 456;
    int256 public i = -3;

    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    /*
    In Solidity, the data type byte represent a sequence of bytes. 
    Solidity presents two types of bytes :

     - fixed-sized byte arrays
     - dynamically-sized byte arrays.
     
     The term bytes in Solidity represents a dynamic array of bytes. 
     It’s a shorthand for byte[] .
    */

    bytes1 public a = 0xa5; // [10110101]
    bytes1 b = 0x56;

    // default value
    bool public defaultBoo;
    uint256 public defaultUint;
    int256 public defaultInt;
    address public defaultAddr;
}