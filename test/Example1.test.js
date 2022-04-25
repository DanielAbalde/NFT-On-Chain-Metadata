const example1 = artifacts.require("Example1ERC721OnChainMetadata");

contract("Example1ERC721OnChainMetadata", (accounts) => { 
  it("print tokenURI", async () => {
    const contract = await example1.deployed(); 
    const uri = await contract.tokenURI(1);
    console.log(uri);
  });
});