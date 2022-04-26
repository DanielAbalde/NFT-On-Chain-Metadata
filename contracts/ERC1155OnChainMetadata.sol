// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
  
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./OnChainMetadata.sol"; 
 
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