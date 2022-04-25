const example2 = artifacts.require("Example2ERC721OnChainMetadata");

contract("Example2ERC721OnChainMetadata", (accounts) => { 
  it("mint token", async () => {
    const contract = await example2.deployed(); 
    await contract.safeMintWithMetadata('red', 'blue', '30');
  });
  it("print tokenURI", async () => {
    const contract = await example2.deployed(); 
    const uri = await contract.tokenURI(0);
    console.log(uri);
  });
});