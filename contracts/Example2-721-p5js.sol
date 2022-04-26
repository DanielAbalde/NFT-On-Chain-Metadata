// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "./ERC721OnChainMetadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// https://testnets.opensea.io/collection/erc721onchainmetadata-with-p5-js

contract Example2ERC721OnChainMetadata is ERC721OnChainMetadata, Ownable
{ 
    bytes32 constant key_token_front_color = "frontColor";
    bytes32 constant key_token_back_color = "backColor";
    bytes32 constant key_token_radius = "radius";
    
    string private _baseURL;
    uint256 private _tokenCount;

    constructor() ERC721OnChainMetadata("ERC721OnChainMetadata Example 2", "Ex2"){
        _baseURL = "https://ipfs.io/ipfs/QmZBApzAghjsTxcS6UuPGqXNd6thuqkbWUrY5bhJJFQtWa/";
        _addValue(_contractMetadata, key_contract_name, abi.encode("ERC721OnChainMetadata with p5.js"));
        _addValue(_contractMetadata, key_contract_description, abi.encode(string(abi.encodePacked("Simple example of ERC721OnChainMetadata using p5.js. See ", "https://github.com/DanielAbalde/NFT-On-Chain-Metadata", "."))));
        _addValue(_contractMetadata, key_contract_image, abi.encode(createSVG("white", "black", "50")));
        _addValue(_contractMetadata, key_contract_external_link, abi.encode("https://github.com/DanielAbalde/NFT-On-Chain-Metadata"));
        _addValue(_contractMetadata, key_contract_seller_fee_basis_points, abi.encode(200));
        _addValue(_contractMetadata, key_contract_fee_recipient, abi.encode(_msgSender()));
    }
   
    function safeMintWithMetadata(string memory frontColor, string memory backColor, string memory radius) public onlyOwner{
        uint256 tokenId = _tokenCount;
        _setValue(tokenId, key_token_name, abi.encode(string(abi.encodePacked(name(), ' #', Strings.toString(tokenId)))));
        _setValue(tokenId, key_token_description, _getValue(key_contract_description));
        _setValue(tokenId, key_token_image, abi.encode(createSVG(frontColor, backColor, radius)));
        _setValue(tokenId, key_token_front_color, abi.encode(frontColor));
        _setValue(tokenId, key_token_back_color, abi.encode(backColor));
        _setValue(tokenId, key_token_radius, abi.encode(radius)); 
      
        bytes[] memory trait_types = new bytes[](3);
        bytes[] memory trait_values = new bytes[](3);
        bytes[] memory trait_display = new bytes[](3);
        trait_types[0] = abi.encode("frontColor");
        trait_types[1] = abi.encode("backColor");
        trait_types[2] = abi.encode("radius");
        trait_values[0] = abi.encode(frontColor);
        trait_values[1] = abi.encode(backColor);
        trait_values[2] = abi.encode(radius);
        trait_display[0] = abi.encode("");
        trait_display[1] = abi.encode("");
        trait_display[2] = abi.encode("");
        _setValues(tokenId, key_token_attributes_trait_type, trait_types);
        _setValues(tokenId, key_token_attributes_trait_value, trait_values);
        _setValues(tokenId, key_token_attributes_display_type, trait_display);
 
        bytes memory url = abi.encodePacked(_baseURL, "?frontColor=", frontColor, "&backColor=", backColor, "&radius=", radius);
        _setValue(tokenId, key_token_animation_url, abi.encode(url));
        
        _tokenCount = _tokenCount + 1;

        _safeMint(_msgSender(), tokenId, ""); 
    }
 
    
    function createSVG(string memory frontColor, string memory backColor, string memory radius) internal pure returns (string memory){   
        return string(abi.encodePacked('data:image/svg+xml;base64,', Base64.encode(bytes(string(abi.encodePacked(
            '<svg height="350" width="350" viewBox="0 0 350 350" xmlns="http://www.w3.org/2000/svg"><rect height="100%" width="100%" fill="', backColor, 
            '"/><circle cx="33%" cy="33%" r="', radius, '" stroke="', backColor, '" stroke-width="1" fill="', frontColor,
             '"><animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 175 175" to="360 175 175" dur="2s" repeatCount="indefinite"/></circle> SVG not supported. </svg>'
        ))))));
  }
 
}
