// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * To write or update a state variable you need to send a transaction.
 * On the other hand, you can read state variables, for free, without any transaction fee.
 */
contract SimpleStorage {
    // state variable to store a number
    uint256 public num;

    // you need to send a transaction to write to a state variable
    function set(uint256 _num) public {
        num = _num;
    }

    // You can read from a state variable without sending a transaction.
    // todo: 不需要发送交易的操作，为什么编译器这里还是显示显示有 gas 消耗？
    // 看了一下 debug 信息，这里的 gas 消耗是 execution cost
    // 另外有 transaction cost，这个好理解
    // 还有单纯的 gas，部署消耗？
    function get() public view returns (uint256) {
        return num;
    }
}
