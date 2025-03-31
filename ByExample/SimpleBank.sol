// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleBank {
    mapping(address => uint256) private balances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);

    modifier OnlyOwner() {
        require(
            owner == msg.sender,
            "Only the contract owner can execute this"
        );
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public OnlyOwner {
        uint256 balance = balances[msg.sender];
        require(amount <= balance, "Not enough balance to withdraw");
        require(balance > 0, "No balance to withdraw");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
