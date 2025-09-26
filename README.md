# 🛒 Decentralized NFT Marketplace

A decentralized NFT marketplace built with Solidity + Hardhat.  
Includes an ERC721 collection contract and a marketplace for listing, buying, and canceling NFT sales.

## ✨ Features
- Mint NFTs using `NFTCollection.sol`
- List of NFTs for sale with custom price
- Buy NFTs securely with ETH
- Cancel listing anytime before sale
- Events emitted for transparency

## 🚀 Getting Started

### 1. Clone repository
```bash
git clone https://github.com/<username>/nft-marketplace.git
cd nft-marketplace

npm install

npx hardhat test

ALCHEMY_API_URL=https://eth-sepolia.g.alchemy.com/v2/<API_KEY>
PRIVATE_KEY=0xabc123...

npx hardhat run scripts/deploy.js --network sepolia

