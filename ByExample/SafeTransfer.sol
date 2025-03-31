// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SafeTransfer {
    address public owner;
    uint public balance;

    /**
     * Error handling is a vital aspect of Solidity programming, as it ensures that contracts operate as intended and prevents unexpected behavior. 
     * By using tools such as require , revert , and assert , developers can write more secure and predictable contracts. 
     */
    function transfer(uint amount) public {
        require(owner == msg.sender, "Only owner can transfer funds");
        require(balance >= amount, "Insufficient funds");

        balance -= amount;
    }

    function withdraw(uint amount) public {
        if (amount > address(this).balance) {
            revert("Not enough Ether in contract");
        }

        payable(msg.sender).transfer(amount);
    }
}