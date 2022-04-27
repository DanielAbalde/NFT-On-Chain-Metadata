require('dotenv').config();

const HDWalletProvider = require("@truffle/hdwallet-provider");
const { API_URL_MATIC, API_URL_MUMBAI, MNEMONIC, API_SCAN, OWNER, DEV } = process.env;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    mumbai: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, API_URL_MUMBAI)
      }, 
      network_id: 80001, 
      gasPrice: 45000000000,
      gas: 20000000, //4M is the max
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true,
      from: DEV
    },
    matic: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, API_URL_MATIC)
      }, 
      network_id: 80001, 
      gasPrice: 45000000000, 
      gas: 20000000, //4M is the max
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
      from: OWNER
    },
    dashboard: {
      port: 24012,
      host: "localhost",
      networkCheckTimeout: 120000,
    }
  },
  compilers: {
    solc: {
      version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
       settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
      //  evmVersion: "byzantium"
      }
    }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    polygonscan: API_SCAN
  }
};