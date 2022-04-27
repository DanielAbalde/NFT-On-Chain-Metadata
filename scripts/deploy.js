require('dotenv').config();

async function main() {

  const [deployer] = await ethers.getSigners(); 
  const wallet = ethers.Wallet.fromMnemonic(process.env.MNEMONIC);
	console.log("Signer:", deployer.address, ", balance: ", (await deployer.getBalance()).toString());
  console.log("Wallet:", wallet.address);

 

  const example1Factory = await ethers.getContractFactory("Example1ERC721OnChainMetadata");
  const example2Factory = await ethers.getContractFactory("Example2ERC721OnChainMetadata");
  const example3Factory = await ethers.getContractFactory("Example3ERC1155OnChainMetadata");
 
  const example1 = await example1Factory.deploy(); 
  const example2 = await example2Factory.deploy(); 
  const example3 = await example3Factory.deploy(); 

  console.log("Example1ERC721OnChainMetadata deployed to:", example1.address);
  console.log("Example2ERC721OnChainMetadata deployed to:", example2.address);
  console.log("Example3ERC1155OnChainMetadata deployed to:", example3.address);
}

main()
 .then(() => process.exit(0))
 .catch(error => {
   console.error(error);
   process.exit(1);
 });