/**
* @type import('hardhat/config').HardhatUserConfig
*/

require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
 
const { API_URL_MATIC, API_URL_MUMBAI, MNEMONIC, PRIVATE_KEY, POLYGONSCAN_API_KEY } = process.env;

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
   solidity: "0.8.1",
   defaultNetwork: "polygon_mumbai",
   networks: {
      hardhat: {},
      polygon_mumbai: {
        url: API_URL_MUMBAI,
        accounts: { mnemonic: MNEMONIC, initialIndex: 0 }, //[`0x${PRIVATE_KEY}`], 
        gasPrice: 45000000000
      },
      polygon_matic:{
        url: API_URL_MATIC,
        accounts: { mnemonic: MNEMONIC, initialIndex: 1 }, //[`0x${PRIVATE_KEY}`], 
        //gasPrice: 45000000000,
        //gas: 20000000 
      }
   },
   gasReporter: {
    enabled: true,
    currency: 'CHF',
    gasPrice: 21
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
 }
}