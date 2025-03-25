// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DataLocations {
    uint256[] public arr;
    mapping(uint256 => address) map;

    struct MyStruct {
        uint256 foo;
    }

    mapping(uint256 => MyStruct) myStructs;

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => address) storage _map,
        MyStruct storage _myStruct
    ) internal {
        // do something with storage variable
    }

    function f() public {
        _f(arr, map, myStructs[0]);
    }

    // You can return memory variables
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // do something with memory variable
    }

    function h(uint256[] calldata _arr) external {
        // do something with calldata array
    }
}
