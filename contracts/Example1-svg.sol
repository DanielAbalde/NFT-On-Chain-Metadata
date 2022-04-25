// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "../contracts/ERC721OnChainMetadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
  
  /*
  https://testnets.opensea.io/collection/erc721onchainmetadata-example-1-6bzpxwdaee
  */
contract Example1ERC721OnChainMetadata is ERC721OnChainMetadata, Ownable
{ 
    constructor() ERC721OnChainMetadata("ERC721OnChainMetadata Example 1", "721OnChain1"){

        _addValue(_contractMetadata, key_contract_name, abi.encode("ERC721OnChainMetadata Example 1"));
        _addValue(_contractMetadata, key_contract_description, abi.encode(string(abi.encodePacked("Simple example of ERC721OnChainMetadata using svg images. See ", "https://github.com/DanielAbalde/HtmlBasedNFT", "."))));
        _addValue(_contractMetadata, key_contract_image, abi.encode(createSVG("blue")));
        _addValue(_contractMetadata, key_contract_external_link, abi.encode("https://github.com/DanielAbalde/HtmlBasedNFT"));
        _addValue(_contractMetadata, key_contract_seller_fee_basis_points, abi.encode(200));
        _addValue(_contractMetadata, key_contract_fee_recipient, abi.encode(_msgSender()));

       _safeMintWithMetadata(1, "First", "First NFT", createSVG("red"), "red");
       _safeMintWithMetadata(2, "Second", "Second NFT", createSVG("green"), "green"); 
       _safeMintWithMetadata(3, "Third", "Third NFT", createSVG("blue"), "blue"); 
    }
       
    function createSVG(string memory color) public pure returns (string memory){   
        return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(string(abi.encodePacked(
            '<svg height="350" width="350" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg"><rect height="100%" width="100%" fill="', color, '"/> SVG not supported. </svg>'
        ))))));
  }
    function _safeMintWithMetadata(uint256 tokenId, string memory name, string memory description, string memory image, string memory trait_color) internal{
        _setValue(tokenId, key_token_name, abi.encode(name));
        _setValue(tokenId, key_token_description, abi.encode(description));
        _setValue(tokenId, key_token_image, abi.encode(image));
        _setValue(tokenId, key_token_attributes_trait_type, abi.encode("color"));
        _setValue(tokenId, key_token_attributes_trait_value, abi.encode(trait_color));
        _setValue(tokenId, key_token_attributes_display_type, abi.encode(""));
        _safeMint(_msgSender(), tokenId, ""); 
    }
}
