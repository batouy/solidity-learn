// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SimpleAuction {
    address public highestBidder;

    uint256 public highestBid;

    uint256 public auctionEndTime;

    address public owner;

    bool public status;

    event HighestBidIncreased(address highestBidder, uint256 newHighestBid);

    event AuctionEnded(address bidder, uint256 amount);

    modifier OnlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can end the auction"
        );
        _;
    }

    modifier auctionActive() {
        require(block.timestamp < auctionEndTime, "Auction has ended");
        _;
    }

    constructor(uint256 biddingTime) {
        owner = msg.sender;
        status = true;
        auctionEndTime = block.timestamp + biddingTime;
    }

    function bid() public payable auctionActive {
        require(msg.value > highestBid, "There already is a higher bid");

        if (highestBid != 0) {
            payable(highestBidder).transfer(highestBid); // Refund the previous highest bidder
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function endAuction() public OnlyOwner {
        require(status, "Auction has not been ended yet");
        require(
            block.timestamp >= auctionEndTime,
            "Not time to end the auction"
        );
        status = false;
        emit AuctionEnded(highestBidder, highestBid);
        payable(owner).transfer(highestBid);
    }
}
