// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    uint256 private count;

    function get() public view returns (uint256) {
        return count;
    }

    function inc() public {
        require(count < 10, "count is too big now");
        count += 1;
    }

    function dec() public {
        require(count > 0, "count is too small now");
        count -= 1;
    }
}
