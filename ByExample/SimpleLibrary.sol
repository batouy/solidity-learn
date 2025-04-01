// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/Strings.sol";

library MyMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        unchecked {
            return a + b;
        }
    }

    function addCurrency(uint256 a, string memory cu)
        internal
        pure
        returns (string memory)
    {
        string memory aStr = Strings.toString(a);
        return string.concat(cu, " ", aStr);
    }
}

contract Calculator {
    using MyMath for uint256;

    function calculateSum(uint256 a, uint256 b) public pure returns (uint256) {
        return a.add(b);
    }

    function showMoney(uint256 a) public pure returns (string memory) {
        return a.addCurrency("BTC");
    }

    // precomputing
    uint256 public constantValue = 10**18; // Precomputed value to save gas

    function compute() public view returns (uint256) {
        // Using precomputed constant instead of recalculating each time
        return constantValue * 2;
    }
}
