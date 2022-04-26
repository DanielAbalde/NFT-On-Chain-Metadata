// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
  
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./OnChainMetadata.sol"; 
 
/**
 * @title ERC721 wrapper to easily create NFTs with on-chain metadata,
 * useful for creating html/js based parametric NFTs or any NFT with dynamic metadata.
 * @author Daniel Gonzalez Abalde aka @DGANFT aka DaniGA#9856.
 * @dev The developer is responsible for assigning metadata for the contract and tokens
 * by inheriting this contract and using _addValue() and _setValue() methods. The tokenURI()
 * and contractURI() methods of this contract are responsible for converting the metadata
 * into a Base64-encoded json readable by OpenSea, LooksRare and many other NFT platforms. 
 */
contract ERC721OnChainMetadata is ERC721, OnChainMetadata
{  
  constructor(string memory name, string memory symbol) ERC721(name, symbol){ }
  
  function tokenURI(uint256 tokenId) public view virtual override(ERC721) returns (string memory)
  {
    require(_exists(tokenId), "tokenId doesn't exist");
    return _createTokenURI(tokenId);
  }

  function contractURI() public view virtual returns (string memory) { 
        return _createContractURI();
  }

}

 