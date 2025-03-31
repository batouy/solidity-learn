// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Voting {
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    mapping(address => bool) private voters;
    Proposal[] private proposals;
    address private owner;

    event Voted(address indexed voter, string indexed proposalName);

    modifier onlyOnce() {
        require(!voters[msg.sender], "You have already voted");
        _;
    }

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Only the contract owner can add proposals"
        );
        _;
    }

    constructor(string[] memory propsalNames) {
        owner = msg.sender;
        for (uint256 i = 0; i < propsalNames.length; i++) {
            proposals.push(Proposal({name: propsalNames[i], voteCount: 0}));
        }
    }

    function vote(uint256 proposalIndex) public onlyOnce {
        require(proposalIndex < proposals.length, "Invalid proposal index");
        voters[msg.sender] = true;
        proposals[proposalIndex].voteCount++;
        emit Voted(msg.sender, proposals[proposalIndex].name);
    }

    function getProposal(uint256 index)
        public
        view
        onlyOwner
        returns (string memory, uint256)
    {
        require(index < proposals.length, "Invalid proposal index");
        Proposal storage proposal = proposals[index];
        return (proposal.name, proposal.voteCount);
    }
}
