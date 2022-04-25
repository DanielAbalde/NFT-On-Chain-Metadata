const example1 = artifacts.require("Example1ERC721OnChainMetadata");
const example2 = artifacts.require("Example2ERC721OnChainMetadata");

module.exports = function (deployer) {
  deployer.deploy(example1);
  deployer.deploy(example2);
};
