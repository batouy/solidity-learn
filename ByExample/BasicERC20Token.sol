// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicERC20Token {
    // Token details
    string public name = "BasicToken"; // Token name
    string public symbol = "BSC"; // Token symbol
    uint8 public decimals = 18; // Number of decimals for divisibility
    uint256 public totalSupply; // Total supply of the token

    // Mapping to store balances and allowances

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    // Events to log transfers and approvals

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // Constructor to initialize the total supply and assign it to the deployer
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * (10**uint256(decimals));
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the contract deployer
    }

    // Transfer function to send tokens from the sender to a recipient
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve function to allow a spender to spend tokens on behalf of the sender
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value; // Set allowance for the spender
        emit Approval(msg.sender, _spender, _value); // Emit approval event
        return true;
    }

    // TransferFrom function to transfer tokens on behalf of an owner
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance"); // Check if owner has enough tokens
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded"); // Check if spender is allowed to spend the specified amount

        balanceOf[_from] -= _value; // Deduct tokens from owner
        balanceOf[_to] += _value; // Add tokens to recipient
        allowance[_from][msg.sender] -= _value; // Update the allowance
        emit Transfer(_from, _to, _value); // Emit transfer event

        return true;
    }
}
