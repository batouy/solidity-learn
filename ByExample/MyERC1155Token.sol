// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyERC1155Token is ERC1155 {
    constructor() ERC1155("https://token-cdn-domain/{id}.json") {
        _mint(msg.sender, 1, 100, ""); // Mint 100 units of token ID 1 to the deployer
    }
}
