const { expect } = require("chai");

describe("NFT Marketplace", function () {
  let Marketplace, marketplace, NFTCollection, nft, owner, seller, buyer;

  beforeEach(async function () {
    [owner, seller, buyer] = await ethers.getSigners();
    NFTCollection = await ethers.getContractFactory("NFTCollection");
    nft = await NFTCollection.deploy();
    await nft.deployed();

    Marketplace = await ethers.getContractFactory("Marketplace");
    marketplace = await Marketplace.deploy();
    await marketplace.deployed();

    // Mint NFT for seller
    await nft.connect(owner).mintNFT(seller.address);
  });

  it("should list and buy NFT", async function () {
    await nft.connect(seller).approve(marketplace.address, 1);
    await marketplace.connect(seller).listNFT(nft.address, 1, ethers.utils.parseEther("1"));

    await expect(
      marketplace.connect(buyer).buyNFT(nft.address, 1, { value: ethers.utils.parseEther("1") })
    ).to.changeEtherBalance(seller, ethers.utils.parseEther("1"));

    expect(await nft.ownerOf(1)).to.equal(buyer.address);
  });

  it("should cancel listing", async function () {
    await nft.connect(seller).approve(marketplace.address, 1);
    await marketplace.connect(seller).listNFT(nft.address, 1, ethers.utils.parseEther("1"));

    await marketplace.connect(seller).cancelListing(nft.address, 1);
    const listing = await marketplace.listings(nft.address, 1);
    expect(listing.active).to.equal(false);
  });
});
