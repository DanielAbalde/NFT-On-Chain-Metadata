// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;
  
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./OnChainMetadata.sol"; 
 
 /**
 * @title On-chain metadata for ERC721,
 * making quick and easy to create html/js NFTs, parametric NFTs or any NFT with dynamic metadata.
 * @author Daniel Gonzalez Abalde aka @DGANFT aka DaniGA#9856.
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

 