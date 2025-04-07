// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicERC721Token {
    string public name = "BasicNFT";
    string public symbol = "BNFT";
    uint256 public totalSupply;
    uint256 public tokenCounter;

    // Mapping to store token owners and approved addresses
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => address) public tokenApprovals;

    // Events to log transfers and approvals
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    constructor() {
        tokenCounter = 0;
    }

    function mint(address _to) public returns (uint256) {
        require(_to != address(0), "Invalid recipient address");
        uint256 newTokenId = tokenCounter;
        ownerOf[newTokenId] = _to;
        tokenCounter++;
        totalSupply++;
        emit Transfer(address(0), _to, newTokenId);
        return newTokenId;
    }

    function approve(uint256 tokenId, address _approved) public {
        require(_approved != address(0), "Invalid recipient address");
        require(tokenApprovals[tokenId] != _approved, "Already approved");

        // Allow tokens to be approved for a specific user
        tokenApprovals[tokenId] = _approved;

        emit Approval(_approved, address(0), tokenId);
    }

    function transfer(address _to, uint256 _tokenId) public {
        address owner = ownerOf[_tokenId];
        require(owner == msg.sender, "Caller is not the owner");
        require(_to != address(0), "Invalid recipient address");
        ownerOf[_tokenId] = _to;
        emit Transfer(owner, _to, _tokenId);
    }
}
