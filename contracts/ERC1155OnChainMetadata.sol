// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
  
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./OnChainMetadata.sol"; 
 
/**
 * @title On-chain metadata for ERC1155,
 * making quick and easy to create html/js NFTs, parametric NFTs or any NFT with dynamic metadata.
 * @author Daniel Gonzalez Abalde aka @DGANFT aka DaniGA#9856.
 * @dev Note that this approach doesn't follow the ERC1155Metadata standard.
 */
contract ERC1155OnChainMetadata is ERC1155, OnChainMetadata
{
  constructor() ERC1155(""){ }

  function uri(uint256 tokenId) public view override(ERC1155) returns (string memory) { 
    return _createTokenURI(tokenId);
  }

  function contractURI() public view virtual returns (string memory) { 
      return _createContractURI();
  }
}