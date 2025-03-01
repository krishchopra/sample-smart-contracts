// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMarketplace {
    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }
    
    mapping(uint256 => Listing) public listings;
    mapping(address => uint256) public pendingWithdrawals;
    
    function listNFT(uint256 _tokenId, uint256 _price) external {
        // Missing ownership verification
        listings[_tokenId] = Listing(msg.sender, _price, true);
    }
    
    function buyNFT(uint256 _tokenId) external payable {
        Listing storage listing = listings[_tokenId];
        require(listing.active, "Not for sale");
        require(msg.value >= listing.price, "Insufficient payment");
        
        // Vulnerable to reentrancy
        listing.active = false;
        pendingWithdrawals[listing.seller] += msg.value;
        
        // Missing NFT transfer
    }
    
    function withdraw() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
