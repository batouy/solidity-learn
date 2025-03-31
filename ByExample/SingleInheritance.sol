// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Animal {
    string public species;

    function setSpecies(string memory _species) public {
        species = _species;
    }
}

contract Dog is Animal {
    string public name;

    function setName(string memory _name) public {
        name = _name;
    }
}
