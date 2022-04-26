const example1 = artifacts.require("Example1ERC721OnChainMetadata");
const example2 = artifacts.require("Example2ERC721OnChainMetadata");
const example3 = artifacts.require("Example3ERC1155OnChainMetadata");

module.exports = function (deployer, network, accounts) {
  const account = accounts[0];
  deployer.deploy(example1, { from: account });
  deployer.deploy(example2, { from: account });
  deployer.deploy(example3, { from: account });
};
