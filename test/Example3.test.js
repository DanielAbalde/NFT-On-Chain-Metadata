const example3 = artifacts.require("Example3ERC1155OnChainMetadata");

contract("Example3ERC1155OnChainMetadata", (accounts) => { 
  it("print tokenURI", async () => {
    const contract = await example3.deployed(); 
    const uri = await contract.uri(0);
    console.log(uri);
  });
});