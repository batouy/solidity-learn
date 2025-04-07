// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicERC1155Token {
    // Mapping to track balances of each token ID for each address
    mapping(uint256 => mapping(address => uint256)) public balances;

    // Event to log transfers
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    // Function to mint new tokens

    function mint(
        address _to,
        uint256 _id,
        uint256 _amount
    ) public {
        require(_to != address(0), "Invalid address");
        balances[_id][_to] += _amount;
        emit TransferSingle(msg.sender, address(0), _to, _id, _amount);
    }

    // Function to transfer tokens
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _amount
    ) public {
        require(_to != address(0), "Invalid address");
        require(balances[_id][_from] >= _amount, "Insufficient balance");
        balances[_id][_from] -= _amount;
        balances[_id][_to] += _amount;
        emit TransferSingle(msg.sender, _from, _to, _id, _amount);
    }
}
