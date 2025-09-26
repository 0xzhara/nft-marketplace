// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Simple ERC721 NFT Collection
contract NFTCollection is ERC721, Ownable {
    uint256 public tokenCounter;

    constructor() ERC721("TalentNFT", "TNFT") {
        tokenCounter = 0;
    }

    function mintNFT(address recipient) public onlyOwner returns (uint256) {
        tokenCounter++;
        _safeMint(recipient, tokenCounter);
        return tokenCounter;
    }
}
