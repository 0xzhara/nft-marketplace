// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title Decentralized NFT Marketplace
contract Marketplace {
    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;

    event Listed(address indexed nft, uint256 indexed tokenId, address seller, uint256 price);
    event Sold(address indexed nft, uint256 indexed tokenId, address buyer, uint256 price);
    event Cancelled(address indexed nft, uint256 indexed tokenId);

    /// @notice List an NFT for sale
    function listNFT(address _nft, uint256 _tokenId, uint256 _price) public {
        require(_price > 0, "Price must be > 0");
        IERC721 nft = IERC721(_nft);
        require(nft.ownerOf(_tokenId) == msg.sender, "Not NFT owner");
        require(nft.getApproved(_tokenId) == address(this), "Marketplace not approved");

        listings[_nft][_tokenId] = Listing(msg.sender, _price, true);

        emit Listed(_nft, _tokenId, msg.sender, _price);
    }

    /// @notice Buy an NFT
    function buyNFT(address _nft, uint256 _tokenId) public payable {
        Listing storage item = listings[_nft][_tokenId];
        require(item.active, "Not listed");
        require(msg.value == item.price, "Incorrect ETH amount");

        item.active = false;
        payable(item.seller).transfer(msg.value);
        IERC721(_nft).transferFrom(item.seller, msg.sender, _tokenId);

        emit Sold(_nft, _tokenId, msg.sender, msg.value);
    }

    /// @notice Cancel listing
    function cancelListing(address _nft, uint256 _tokenId) public {
        Listing storage item = listings[_nft][_tokenId];
        require(item.seller == msg.sender, "Not seller");
        require(item.active, "Already inactive");

        item.active = false;
        emit Cancelled(_nft, _tokenId);
    }
}
